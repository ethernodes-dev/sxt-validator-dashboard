#!/usr/bin/env python3
"""
SXT Validator Dashboard — Historical data backfill

Populates sxt.delegation_snapshots and sxt.era_rewards with historical data
for eras where the live exporter was not yet running. Intended to be run ONCE
after the first `docker compose up`, so that the dashboard shows meaningful
history from day one.

Usage:
    # Auto-detect range and backfill everything (recommended first-run):
    docker compose exec sxt-exporter python3 /app/scripts/backfill.py all

    # Only stake/delegation data:
    docker compose exec sxt-exporter python3 /app/scripts/backfill.py stake

    # Only rewards/commission data (assumes stake rows already exist):
    docker compose exec sxt-exporter python3 /app/scripts/backfill.py rewards

    # Manual range override:
    docker compose exec sxt-exporter python3 /app/scripts/backfill.py all \\
        --from 300 --to 350

    # Dry run (no writes):
    docker compose exec sxt-exporter python3 /app/scripts/backfill.py all --dry-run

Scope:
    By default, the backfill covers up to the last 100 eras (~100 days on SXT
    mainnet with 24h eras). This limit keeps RPC usage reasonable and dashboard
    startup fast. Override with --max-eras N if needed.

Public RPC note:
    The default endpoint https://rpc.mainnet.sxt.network is public and
    load-balanced, with some requests failing due to backend inconsistency.
    This script automatically retries up to 20 times per query.
    If you run your own archive node, set SXT_BACKFILL_RPC to point at it.
"""
import argparse
import logging
import os
import sys
import time
from typing import Any, Dict, List, Optional, Tuple

import requests

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
log = logging.getLogger("backfill")

# ---------------------------------------------------------------------------
# Config (env-overridable)
# ---------------------------------------------------------------------------
RPC_URL = os.getenv("SXT_BACKFILL_RPC", "https://rpc.mainnet.sxt.network")
VALIDATOR_NAMES_URL = os.getenv(
    "SXT_VALIDATOR_NAMES_URL",
    "https://staking.spaceandtime.io/api/validator",
)
CH_HOST = os.getenv("SXT_CLICKHOUSE_HOST", "clickhouse")
CH_PORT = int(os.getenv("SXT_CLICKHOUSE_PORT", "8123"))
CH_DB = os.getenv("SXT_CLICKHOUSE_DB", "sxt")
CH_USER = os.getenv("SXT_CLICKHOUSE_USER", "sxt_exporter")
CH_PASSWORD = os.getenv("SXT_CLICKHOUSE_PASSWORD", "")

# Approximate blocks per era on SXT mainnet. Used for linear extrapolation to
# locate the first block of any given era. SXT runs 24h eras with ~6s blocks.
BLOCKS_PER_ERA_APPROX = 27_500

# Hard cap to prevent operators from issuing accidentally huge backfills.
DEFAULT_MAX_ERAS = 80
ABSOLUTE_MAX_ERAS = 500  # even with --max-eras, cap at this

# Query retry tuning for public RPC
QUERY_RETRIES = 20
QUERY_BACKOFF_SECONDS = 0.2
ERA_DELAY_SECONDS = float(os.getenv("SXT_BACKFILL_ERA_DELAY", "0.5"))


# ---------------------------------------------------------------------------
# ClickHouse HTTP
# ---------------------------------------------------------------------------
def ch_query(sql: str, data: Optional[str] = None) -> str:
    url = f"http://{CH_HOST}:{CH_PORT}/"
    params = {"database": CH_DB, "query": sql}
    auth = (CH_USER, CH_PASSWORD) if CH_USER else None
    resp = requests.post(url, params=params, data=data, auth=auth, timeout=30)
    if resp.status_code != 200:
        raise RuntimeError(f"ClickHouse error {resp.status_code}: {resp.text[:300]}")
    return resp.text


def ch_existing_eras(table: str) -> set:
    out = ch_query(f"SELECT DISTINCT era FROM {table} FORMAT TSV").strip()
    if not out:
        return set()
    return {int(x) for x in out.split("\n") if x}


# ---------------------------------------------------------------------------
# Substrate connection + retry wrapper
# ---------------------------------------------------------------------------
def connect_substrate():
    from substrateinterface import SubstrateInterface
    log.info("Connecting to substrate RPC at %s", RPC_URL)
    sub = SubstrateInterface(url=RPC_URL, auto_reconnect=False)
    log.info("Connected. Chain: %s, runtime spec: %s",
             sub.chain, sub.runtime_version)
    return sub


def query_retry(sub_ref: list, method_name: str, *args, **kwargs) -> Any:
    """Retry a substrate-interface call up to QUERY_RETRIES times for
    backend-routing errors (load-balanced public RPCs)."""
    last_exc = None
    for _ in range(QUERY_RETRIES):
        try:
            return getattr(sub_ref[0], method_name)(*args, **kwargs)
        except Exception as e:
            last_exc = e
            msg = str(e)
            if "State already discarded" not in msg and "UnknownBlock" not in msg:
                raise
            time.sleep(QUERY_BACKOFF_SECONDS)
    raise last_exc if last_exc else RuntimeError("query exhausted")


# ---------------------------------------------------------------------------
# Validator name mapping (ss58 -> name)
# ---------------------------------------------------------------------------
def fetch_validator_mapping() -> Dict[str, str]:
    """Fetch validator names from the public SXT staking API.
    Falls back to a short ss58 if a validator is not in the mapping."""
    try:
        log.info("Fetching validator names from %s", VALIDATOR_NAMES_URL)
        resp = requests.get(VALIDATOR_NAMES_URL, timeout=15)
        resp.raise_for_status()
        data = resp.json()
        mapping = {e["id"]: e["name"] for e in data.get("data", [])
                   if e.get("id") and e.get("name")}
        log.info("Got %d validator mappings", len(mapping))
        return mapping
    except Exception as e:
        log.warning("Could not fetch validator mapping (%s), will use ss58 only",
                    str(e)[:80])
        return {}


def name_for(ss58: str, mapping: Dict[str, str]) -> str:
    if ss58 in mapping:
        return mapping[ss58]
    return ss58[:8] + ".." + ss58[-4:]


# ---------------------------------------------------------------------------
# Block location (linear extrapolation + bounded scan)
# ---------------------------------------------------------------------------
def get_block_hash_for_era(sub_ref: list, era: int, current_block: int,
                           current_era: int) -> Optional[str]:
    """Find a block hash where ActiveEra == era. Any block inside the era works."""
    if era == current_era:
        return query_retry(sub_ref, "get_block_hash", current_block)
    if era > current_era:
        return None

    era_diff = current_era - era
    block = max(1, current_block - era_diff * BLOCKS_PER_ERA_APPROX)

    def _era_at(b: int) -> Optional[int]:
        try:
            h = query_retry(sub_ref, "get_block_hash", b)
            if not h:
                return None
            r = query_retry(sub_ref, "query", "Staking", "ActiveEra", block_hash=h)
            return r.value["index"] if r and r.value else None
        except Exception:
            return None

    guess_era = _era_at(block)
    if guess_era is None:
        log.error("Era %d: anchor failed at block %d", era, block)
        return None

    step = BLOCKS_PER_ERA_APPROX
    max_jumps = 10
    while guess_era != era and max_jumps > 0:
        max_jumps -= 1
        if guess_era > era:
            block -= step
        else:
            block += step
        if block < 1 or block > current_block:
            break
        new_era = _era_at(block)
        if new_era is None:
            break
        if (guess_era > era and new_era < era) or (guess_era < era and new_era > era):
            step = max(1, step // 2)
        guess_era = new_era

    if guess_era != era:
        log.warning("Era %d: could not locate (last block=%d era=%d)",
                    era, block, guess_era)
        return None

    return query_retry(sub_ref, "get_block_hash", block)


# ---------------------------------------------------------------------------
# Range resolution
# ---------------------------------------------------------------------------
def resolve_range(sub_ref: list, mode: str, args_from: Optional[int],
                  args_to: Optional[int], max_eras: int,
                  force: bool = False) -> Tuple[int, int, int, int]:
    """Determine (from_era, to_era, current_block, current_era) respecting
    the max_eras cap and existing ClickHouse data.

    Auto-detect logic (when --from/--to are not given):
      - to_era   = current_era - 1   (active era is in progress, skip it)
      - from_era = current_era - max_eras  by default

    For mode='all' we now look at BOTH tables and start from the smaller
    of the two MAX(era) values (i.e. the table that is most behind).
    Previously we only checked one table; this caused the script to do
    nothing when the live exporter had already inserted a single row
    into delegation_snapshots while era_rewards was still empty.

    With --force, the existing data is ignored entirely and we always
    start from current_era - max_eras.  Re-inserting is harmless because
    both tables are ReplacingMergeTree (deduplication on FINAL/argMax).
    """
    current_header = sub_ref[0].get_block_header()
    current_block = current_header["header"]["number"]
    head_hash = query_retry(sub_ref, "get_block_hash", current_block)
    active = query_retry(sub_ref, "query", "Staking", "ActiveEra", block_hash=head_hash)
    if not active or not active.value:
        raise RuntimeError("Could not read current active era from chain")
    current_era = active.value["index"]
    log.info("Chain head: block #%d, active era %d", current_block, current_era)

    to_era = current_era - 1  # don't backfill active era (still in progress)

    if args_from is not None and args_to is not None:
        from_era = args_from
        to_era = args_to
    elif force:
        from_era = current_era - max_eras
        log.info("Force mode: ignoring existing CH data, starting at era %d",
                 from_era)
    else:
        # Auto-detect: start at the era *after* the latest era for which BOTH
        # required tables already have data.  If either table is empty (or
        # not relevant for this mode), we treat that table's "max known era"
        # as -inf so it does not constrain us.
        relevant = []
        if mode in ("all", "stake"):
            relevant.append(ch_existing_eras("sxt.delegation_snapshots"))
        if mode in ("all", "rewards"):
            relevant.append(ch_existing_eras("sxt.era_rewards"))

        # All required tables must have at least one row to "shortcut".
        if relevant and all(s for s in relevant):
            # Smallest MAX(era) across required tables drives the resume point.
            max_per_table = [max(s) for s in relevant]
            resume_from = min(max_per_table) + 1
            log.info("Existing eras per table (min max): %s -> resume at %d",
                     max_per_table, resume_from)
            from_era = resume_from
        else:
            from_era = current_era - max_eras
            log.info("At least one required table is empty -> "
                     "full backfill from era %d", from_era)

        # Enforce the cap regardless of how from_era was chosen.
        from_era = max(from_era, current_era - max_eras)
        from_era = max(from_era, 1)

    if from_era > to_era:
        log.info("Nothing to backfill: from=%d > to=%d (already up to date?)",
                 from_era, to_era)
        log.info("If you want to re-process the last %d eras anyway, "
                 "re-run with --force.", max_eras)
        return (from_era, to_era, current_block, current_era)

    span = to_era - from_era + 1
    if span > max_eras:
        log.warning("Requested range %d-%d (%d eras) exceeds --max-eras %d. "
                    "Truncating to last %d eras.",
                    from_era, to_era, span, max_eras, max_eras)
        from_era = to_era - max_eras + 1

    log.info("Backfill range: eras %d..%d (%d eras)",
             from_era, to_era, to_era - from_era + 1)
    return (from_era, to_era, current_block, current_era)


# ---------------------------------------------------------------------------
# Stake reader
# ---------------------------------------------------------------------------
def read_era_stake(sub_ref: list, era: int, block_hash: str,
                   mapping: Dict[str, str]) -> List[Dict]:
    """Read ErasStakersOverview for all known validators at block_hash.
    Falls back to ErasStakers (legacy) for older eras."""
    rows = []
    for ss58 in mapping.keys():
        total = own = 0.0
        nom = 0
        got = False
        try:
            ov = query_retry(sub_ref, "query", "Staking", "ErasStakersOverview",
                             params=[era, ss58], block_hash=block_hash)
            if ov and ov.value:
                total = ov.value.get("total", 0) / 1e18
                own = ov.value.get("own", 0) / 1e18
                nom = ov.value.get("nominator_count", 0)
                got = True
        except Exception:
            pass
        if not got:
            try:
                st = query_retry(sub_ref, "query", "Staking", "ErasStakers",
                                 params=[era, ss58], block_hash=block_hash)
                if st and st.value:
                    total = st.value.get("total", 0) / 1e18
                    own = st.value.get("own", 0) / 1e18
                    others = st.value.get("others", [])
                    nom = len(others)
                    got = True
            except Exception:
                pass
        if not got or total == 0:
            continue
        rows.append({
            "ss58": ss58,
            "name": mapping.get(ss58, ss58[:8] + ".." + ss58[-4:]),
            "total_stake": total,
            "own_stake": own,
            "delegated_stake": total - own,
            "nominator_count": nom,
        })
    return rows


def era_timestamp_at(sub_ref: list, block_hash: str) -> str:
    """Get block timestamp formatted for ClickHouse DateTime64(3)."""
    try:
        ts = query_retry(sub_ref, "query", "Timestamp", "Now", block_hash=block_hash)
        ms = ts.value if ts and ts.value else int(time.time() * 1000)
    except Exception:
        ms = int(time.time() * 1000)
    t = time.gmtime(ms / 1000)
    frac = int(ms % 1000)
    return time.strftime("%Y-%m-%d %H:%M:%S", t) + f".{frac:03d}"


# ---------------------------------------------------------------------------
# Rewards reader
# ---------------------------------------------------------------------------
def read_era_rewards(sub_ref: list, era: int, block_hash: str,
                     mapping: Dict[str, str]) -> List[Dict]:
    """Read reward points, total reward, and per-validator commission."""
    # Total reward — MUST be queried at HEAD (materialized post-era-end)
    try:
        head_h = query_retry(sub_ref, "get_block_hash",
                             sub_ref[0].get_block_header()["header"]["number"])
        evr = query_retry(sub_ref, "query", "Staking", "ErasValidatorReward",
                          params=[era], block_hash=head_h)
        era_reward = evr.value / 1e18 if evr and evr.value is not None else 0.0
    except Exception:
        era_reward = 0.0

    # Points
    try:
        erp = query_retry(sub_ref, "query", "Staking", "ErasRewardPoints",
                          params=[era], block_hash=block_hash)
        if not erp or not erp.value:
            return []
        total_points = erp.value.get("total", 0)
        points_by = {x[0]: x[1] for x in erp.value.get("individual", [])
                     if len(x) == 2}
    except Exception as e:
        log.error("Era %d: reward points failed: %s", era, str(e)[:80])
        return []

    rows = []
    for ss58, pts in points_by.items():
        try:
            evp = query_retry(sub_ref, "query", "Staking", "ErasValidatorPrefs",
                              params=[era, ss58], block_hash=block_hash)
            commission = evp.value.get("commission", 0) / 1e9 * 100 \
                         if evp and evp.value else 0.0
        except Exception:
            commission = 0.0
        vreward = era_reward * (pts / total_points) if total_points > 0 else 0.0
        rows.append({
            "ss58": ss58,
            "name": name_for(ss58, mapping),
            "era_points": int(pts),
            "era_total_points": int(total_points),
            "commission_pct": round(commission, 2),
            "era_total_reward": round(era_reward, 6),
            "validator_reward": round(vreward, 6),
        })
    return rows


# ---------------------------------------------------------------------------
# Writers
# ---------------------------------------------------------------------------
def write_stake(era: int, rows: List[Dict], ts: str) -> int:
    lines = []
    for r in rows:
        name = r["name"].replace("\t", " ")
        lines.append(
            f"{ts}\t{era}\t{name}\t{name}\t"
            f"{r['total_stake']}\t{r['own_stake']}\t{r['delegated_stake']}\t"
            f"{r['nominator_count']}\t0"
        )
    if not lines:
        return 0
    payload = "\n".join(lines) + "\n"
    ch_query("INSERT INTO delegation_snapshots FORMAT TabSeparated", data=payload)
    return len(lines)


def fetch_existing_stake(era: int) -> Dict[str, Dict]:
    """Preserve stake fields from prior INSERT when running rewards-only pass."""
    sql = (f"SELECT validator_address, total_stake, own_stake, nominator_count, "
           f"is_active FROM sxt.era_rewards WHERE era = {era} FORMAT TSV")
    out = ch_query(sql).strip()
    result = {}
    for line in out.split("\n"):
        parts = line.split("\t")
        if len(parts) < 5:
            continue
        result[parts[0]] = {
            "total_stake": float(parts[1]), "own_stake": float(parts[2]),
            "nominator_count": int(parts[3]), "is_active": int(parts[4]),
        }
    return result


def write_era_rewards(era: int, reward_rows: List[Dict],
                      stake_rows: List[Dict], ts: str) -> int:
    """Write to era_rewards. If stake_rows is empty, try to preserve existing
    stake data from a prior pass; otherwise combine reward + stake data here."""
    # Build a name->stake dict. If we computed stake in the same run, use that.
    # Otherwise read from CH (for rewards-only mode).
    if stake_rows:
        stake_by_name = {r["name"]: {
            "total_stake": r["total_stake"], "own_stake": r["own_stake"],
            "nominator_count": r["nominator_count"], "is_active": 1
        } for r in stake_rows}
    else:
        stake_by_name = fetch_existing_stake(era)

    lines = []
    for r in reward_rows:
        name = r["name"].replace("\t", " ")
        stake = stake_by_name.get(name, {})
        total_stake = stake.get("total_stake", 0.0)
        own_stake = stake.get("own_stake", 0.0)
        nom = stake.get("nominator_count", 0)
        is_active = stake.get("is_active", 1)
        lines.append(
            f"{era}\t{name}\t{name}\t"
            f"{total_stake}\t{own_stake}\t{nom}\t"
            f"{r['commission_pct']}\t{r['era_points']}\t{r['era_total_points']}\t"
            f"{r['era_total_reward']}\t{r['validator_reward']}\t"
            f"{is_active}\t{ts}"
        )
    if not lines:
        return 0
    payload = "\n".join(lines) + "\n"
    ch_query("INSERT INTO era_rewards FORMAT TabSeparated", data=payload)
    return len(lines)


# ---------------------------------------------------------------------------
# Orchestration
# ---------------------------------------------------------------------------
def run_backfill(mode: str, from_era: int, to_era: int, current_block: int,
                 current_era: int, mapping: Dict[str, str],
                 sub_ref: list, dry_run: bool) -> Dict[str, int]:
    summary = {"ok": 0, "failed": 0, "skipped": 0}
    existing_stake = ch_existing_eras("sxt.delegation_snapshots") if mode != "stake" else set()
    existing_rewards = ch_existing_eras("sxt.era_rewards") if mode != "stake" else set()

    for era in range(from_era, to_era + 1):
        log.info("--- Era %d ---", era)
        time.sleep(ERA_DELAY_SECONDS)

        # Fresh substrate connection per era (helps with internal caching)
        try:
            sub_ref[0].close()
        except Exception:
            pass
        sub_ref[0] = connect_substrate()
        try:
            current_block = sub_ref[0].get_block_header()["header"]["number"]
        except Exception as e:
            log.error("Era %d: could not refresh head: %s", era, str(e)[:80])
            summary["failed"] += 1
            continue

        block_hash = get_block_hash_for_era(sub_ref, era, current_block, current_era)
        if not block_hash:
            log.error("Era %d: could not locate block", era)
            summary["failed"] += 1
            continue

        ts = era_timestamp_at(sub_ref, block_hash)
        stake_rows = []
        reward_rows = []

        # --- Stake ---
        if mode in ("all", "stake"):
            stake_rows = read_era_stake(sub_ref, era, block_hash, mapping)
            if not stake_rows:
                log.warning("Era %d: no stake data (likely pruned by archive RPC; "
                            "try a lower --from or deploy your own archive node)", era)
            else:
                log.info("  Stake: %d validators read", len(stake_rows))
                if not dry_run:
                    written = write_stake(era, stake_rows, ts)
                    log.info("  Stake: inserted %d rows into delegation_snapshots", written)
                else:
                    log.info("  [DRY] Would insert %d stake rows", len(stake_rows))

        # --- Rewards ---
        if mode in ("all", "rewards"):
            reward_rows = read_era_rewards(sub_ref, era, block_hash, mapping)
            if not reward_rows:
                log.warning("Era %d: no reward data", era)
            else:
                log.info("  Rewards: total=%.2f SXT, %d validators with points",
                         reward_rows[0]["era_total_reward"], len(reward_rows))
                if not dry_run:
                    written = write_era_rewards(era, reward_rows, stake_rows,
                                                time.strftime("%Y-%m-%d %H:%M:%S.000",
                                                              time.gmtime()))
                    log.info("  Rewards: wrote %d rows into era_rewards", written)
                else:
                    log.info("  [DRY] Would update %d reward rows", len(reward_rows))

        if stake_rows or reward_rows:
            summary["ok"] += 1
        else:
            summary["failed"] += 1

    return summary


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(
        description="SXT Validator Dashboard historical data backfill",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="See the module docstring for examples.",
    )
    parser.add_argument("mode", choices=["all", "stake", "rewards"],
                        help="Which data to backfill")
    parser.add_argument("--from", dest="from_era", type=int, default=None,
                        help="First era (inclusive). Default: auto-detect.")
    parser.add_argument("--to", dest="to_era", type=int, default=None,
                        help="Last era (inclusive). Default: current era - 1.")
    parser.add_argument("--max-eras", type=int, default=DEFAULT_MAX_ERAS,
                        help=f"Hard cap on span. Default: {DEFAULT_MAX_ERAS}.")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--force", action="store_true",
                        help="Ignore existing CH data and backfill the full "
                             "max_eras window from current_era - max_eras up "
                             "to current_era - 1.  Re-inserts are harmless "
                             "because both target tables are ReplacingMergeTree.")
    args = parser.parse_args()

    if args.max_eras > ABSOLUTE_MAX_ERAS:
        log.error("--max-eras %d exceeds absolute limit %d",
                  args.max_eras, ABSOLUTE_MAX_ERAS)
        return 1
    if (args.from_era is None) != (args.to_era is None):
        log.error("Use both --from and --to, or neither (for auto-detect)")
        return 1

    log.info("SXT Dashboard backfill — mode=%s %s",
             args.mode, "(DRY RUN)" if args.dry_run else "(WRITE)")

    mapping = fetch_validator_mapping()

    sub = connect_substrate()
    sub_ref = [sub]

    try:
        from_era, to_era, current_block, current_era = resolve_range(
            sub_ref, args.mode, args.from_era, args.to_era, args.max_eras,
            force=args.force,
        )
    except Exception as e:
        log.error("Range resolution failed: %s", e)
        return 3

    if from_era > to_era:
        return 0

    summary = run_backfill(args.mode, from_era, to_era, current_block,
                           current_era, mapping, sub_ref, args.dry_run)

    log.info("===== Summary =====")
    log.info("  OK:      %d", summary["ok"])
    log.info("  Failed:  %d", summary["failed"])
    log.info("  Skipped: %d", summary["skipped"])
    return 0 if summary["failed"] == 0 else 2


if __name__ == "__main__":
    sys.exit(main())
