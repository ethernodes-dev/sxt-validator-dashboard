# SXT Validator Dashboard

A self-hosted, open-source monitoring dashboard for [Space and Time](https://www.spaceandtime.io)
mainnet validators.  Tracks chain status, network economics, per-validator
earnings, stake evolution, and host metrics — all in one Grafana page.

[IMG]

Built and maintained by [Ethernodes](https://github.com/talinito).
For questions, ping `talinito` on Discord.

---

## What it shows

The dashboard groups panels into six rows, each focused on one operational
concern:

- **Protocol overview** — current era, finalized vs best block height, total
  network stake, validator counts, RPC health.
- **Network economics** — SXT price (CoinGecko), total network stake in USD,
  era reward issuance, historical price chart.
- **Validators — global stats** — per-validator stake, era points, status
  (active / waiting), full validator table sortable by every column,
  estimated APR over time, stake-per-validator over time.
- **Validator economics** — for the validator the dashboard is configured
  for: earnings per era, monthly earnings split by commission and own yield,
  84-day totals, total stake over time.
- **This validator** — chain-level metrics for *your* node: peers, finality
  lag, block proposal/import times, network bandwidth.
- **Host machine** — CPU / RAM / disk / network from `node_exporter` running
  on the validator host.

---

## Quick start

You will need:

- A Linux host with Docker 20.10+ and Docker Compose v2.
- An SXT validator with the built-in Prometheus exposition enabled.  The
  SXT node binary is Substrate-based and exposes metrics natively when
  started with these flags:
  ```
  --prometheus-external --prometheus-port 9615
  ```
  No separate Prometheus install is needed on the validator host — only
  `node_exporter` (below) for host-level metrics.
- The SXT node's Substrate RPC reachable on TCP (default port `9944`).
  This is needed for the staking deep collection.  The exporter MUST
  point to **your own node** via `SXT_RPC_URL`, never to a public RPC
  endpoint — public RPCs are load-balanced and idle-close WebSockets,
  which causes the staking loop to stall.
- `node_exporter` running on that same validator host (default `9100`).
- ~10 GB free disk for ClickHouse data and 80-day backfill.

Then:

```bash
git clone https://github.com/talinito/sxt-validator-dashboard.git
cd sxt-validator-dashboard
./install.sh
```

The installer is interactive.  It walks through pre-flight checks, asks for
your validator name (validated against the live SXT staking API), endpoint
addresses, host ports (auto-detects collisions), generates strong random
passwords, lays down `.env` (mode 600), starts the stack, and offers to
launch the historical backfill in the background.

When it finishes, Grafana is reachable at `http://127.0.0.1:3000` (or the
port you chose).  See **Deployment topologies** below for how to expose it
beyond the host.

---

## Architecture

```
   ┌──────────────────────────┐         ┌─────────────────────────┐
   │  SXT validator host      │         │  Dashboard host         │
   │  (your node)             │         │                         │
   │                          │         │  ┌────────────────────┐ │
   │  ┌──────────────────┐    │         │  │  sxt-exporter      │ │
   │  │  SXT node        ├────┼─ 9615 ──┼──┤  (Python)          │ │
   │  │  --prometheus-   │    │  HTTP   │  │  reads stake,      │ │
   │  │   external       │    │         │  │  rewards via RPC   │ │
   │  └──────────────────┘    │         │  └────────┬───────────┘ │
   │                          │         │           │             │
   │  ┌──────────────────┐    │         │  ┌────────▼───────────┐ │
   │  │  node_exporter   ├────┼─ 9100 ──┤  │  Prometheus        │ │
   │  └──────────────────┘    │  HTTP   │  │  + ClickHouse      │ │
   └──────────────────────────┘         │  │  (time-series DB)  │ │
                                        │  └────────┬───────────┘ │
                                        │           │             │
                                        │  ┌────────▼───────────┐ │
                                        │  │  Grafana           │ │
                                        │  │  (visualization)   │ │
                                        │  └────────────────────┘ │
                                        └─────────────────────────┘
```

**Two data stores by design:**

- **Prometheus** — all live metrics (15s scrape, 30d retention).
- **ClickHouse** — long-term historical data (era rewards, stake snapshots,
  commission totals, price history).  Survives Prometheus retention rotation.

The exporter writes to both: short-term metrics to Prometheus via its
exposition endpoint, per-era summaries to ClickHouse on era transition.

---

## Deployment topologies

### Topology 1 — Single-host

The validator and the dashboard run on the same machine.  The exporter
reaches the validator via the Docker bridge gateway (`172.17.0.1`).

`.env` looks like:

```env
SXT_PROMETHEUS_TARGET=172.17.0.1:9615
NODE_EXPORTER_TARGET=172.17.0.1:9100
```

This is the simplest topology, and the installer's defaults assume it.

### Topology 2 — Remote dashboard

The dashboard runs on a separate host from the validator.  The exporter
scrapes the validator's public IP.

`.env` looks like:

```env
SXT_PROMETHEUS_TARGET=<validator_public_ip>:9615
NODE_EXPORTER_TARGET=<validator_public_ip>:9100
```

You **must** open ports 9615 and 9100 on the validator's firewall *only*
for the dashboard host's IP.  Example with UFW:

```bash
sudo ufw allow from <dashboard_host_ip> to any port 9615 proto tcp
sudo ufw allow from <dashboard_host_ip> to any port 9100 proto tcp
sudo ufw reload
```

Both endpoints serve over HTTP without authentication.  In Topology 2
you have two options:

1. Restrict by source IP at the validator firewall (above).
2. Run an SSH tunnel from the dashboard host to the validator host and
   point the targets at `127.0.0.1`.  More setup, but tunnel-encrypted and
   no public exposure of the metrics ports.

### Exposing Grafana publicly

By default Grafana binds to `127.0.0.1` only.  Access it from your laptop
via SSH tunnel:

```bash
ssh -L 3000:127.0.0.1:3000 <user>@<dashboard_host>
# then open http://localhost:3000
```

For permanent public access (e.g. a custom domain), put your own reverse
proxy + TLS in front of Grafana.  This repo does not ship nginx, Caddy,
or certificate provisioning — that is your operations decision.  The
installer just needs to know whether to bind to `127.0.0.1` (recommended)
or `0.0.0.0`.

---

## Configuration reference

`.env` (created by the installer) contains:

| Variable | Description | Default |
|---|---|---|
| `SXT_LOCAL_VALIDATOR` | Display name of your validator (must match the staking API) | — |
| `SXT_RPC_URL` | Substrate RPC endpoint of **your** node, e.g. `http://<node_ip>:9944` (the exporter rewrites the scheme to `ws://` internally).  Never use a public RPC. | `http://172.17.0.1:9944` |
| `SXT_RECONNECT_AFTER_FAILURES` | Force a fresh substrate WebSocket reconnect after this many consecutive collection failures. | `10` |
| `SXT_STALE_HEALTH_SECONDS` | `/health` returns 503 if no successful collection has occurred in this many seconds.  Triggers docker healthcheck to restart the container. | `300` |
| `SXT_MAX_BACKOFF_SECONDS` | Cap of the exponential backoff applied between failed collection attempts. | `30` |
| `SXT_PROMETHEUS_TARGET` | Validator's Prometheus endpoint | `172.17.0.1:9615` |
| `NODE_EXPORTER_TARGET` | Host metrics endpoint | `172.17.0.1:9100` |
| `SXT_DATA_MOUNTPOINT` | Mountpoint of the validator's data dir | `/sxt-data` |
| `GRAFANA_PORT` / `GRAFANA_BIND` | Where Grafana listens | `3000` / `127.0.0.1` |
| `PROMETHEUS_PORT` | Prometheus host port | `9090` |
| `CLICKHOUSE_HTTP_PORT` / `CLICKHOUSE_NATIVE_PORT` | ClickHouse host ports | `8123` / `9000` |
| `SXT_EXPORTER_PORT` | Custom exporter exposition port | `9101` |
| `*_PASSWORD` | Auto-generated strong passwords (24 base64 chars) | — |

All ports are configurable.  The installer detects host-port collisions
and suggests alternatives, or you can preset values via env vars before
running it.

---

## Day-to-day operations

`./start.sh` is the operator-facing wrapper.  Run from the repo root:

```bash
./start.sh status        # container + scrape target health
./start.sh logs          # follow all logs
./start.sh logs grafana  # follow one service
./start.sh restart       # restart the stack
./start.sh down          # stop everything (data preserved)
./start.sh render        # re-render templates from .env without restarting
```

For the historical backfill (run once per fresh install):

```bash
docker compose exec sxt-exporter \
    python3 /app/scripts/backfill.py all --force
```

`--force` is required because the live exporter writes the current era
immediately on startup; without it, the backfill thinks it has nothing
to do.

The backfill walks the last 80 eras (~80 days of mainnet history).
Roughly one minute per era is normal on the public RPC; pointing
`SXT_BACKFILL_RPC` at your own archive node cuts the wall-clock time
significantly.

---

## Security model

The default install lays down a defensible baseline:

- **Two ClickHouse users.**  `sxt_exporter` (write access, used by the
  exporter and backfill) and `sxt_dashboard` (read-only, used by Grafana).
  A SQL injection through a Grafana panel can neither mutate data nor
  exfiltrate beyond the `sxt.*` schema.
- **Read-only resource profile** on `sxt_dashboard`: `readonly=1`,
  `max_memory_usage=2GB`, `max_execution_time=30s`,
  `max_result_rows=100k`.  Caps DoS via crafted queries.
- **`127.0.0.1` bind by default** for all services.  Operators choose
  their own exposure path (reverse proxy + TLS, SSH tunnel, IP allowlist).
- **Strong passwords by default.**  The installer generates with
  `openssl rand -base64 24` and writes `.env` mode `600`.
- **No hardcoded secrets in the repo.**  Everything secret lives in `.env`,
  which is gitignored.  Templates `(*.tpl)` are rendered to runtime files
  at boot and those rendered files are also gitignored.
- **Pinned plugin versions.**  Grafana plugins use exact pins for
  reproducibility; updates are explicit, not opportunistic.
- **Pinned Python dependencies.**  Same idea for the exporter image.

---

## Troubleshooting

### Backfill says "nothing to do" but the database is empty

The live exporter writes the current era to ClickHouse on its first poll,
so `backfill.py` sees a row, computes a resume point past the end of the
window you asked for, and exits.  Use `--force`:

```bash
docker compose exec sxt-exporter \
    python3 /app/scripts/backfill.py all --force
```

### `port already in use` when bringing the stack up

Another stack on the same host is using one of the default ports.  Either
pick alternatives via env vars and re-run `install.sh`:

```bash
GRAFANA_PORT=3002 PROMETHEUS_PORT=9092 ./install.sh
```

…or run the installer from scratch and let it auto-suggest free ports.

### Grafana UI says "you don't have permission" when creating users

If you put a reverse proxy in front of Grafana, you may have blocked
`/api/admin/*` for non-loopback traffic.  This is a common (and
recommended) hardening step.

To create or manage users, open an SSH tunnel from your laptop directly
to Grafana, bypassing the reverse proxy:

```bash
ssh -L 3000:127.0.0.1:3000 <user>@<dashboard_host>
# then open http://localhost:3000 and log in as admin
```

Or use the API:

```bash
curl -u admin:<admin_pwd> -X POST -H "Content-Type: application/json" \
    -d '{"name":"viewer","email":"viewer@example.com","login":"viewer","password":"strong-pwd"}' \
    http://127.0.0.1:3000/api/admin/users
```

### Some panels return 503 during the backfill

ClickHouse is busy ingesting batched inserts and its query engine slows
down.  Dashboard queries with the `max_execution_time=30s` cap can time
out and surface as 503 in the browser console.  This clears up on its
own once backfill finishes.

If you need to ride this out, you can temporarily relax the limit:

```sql
ALTER SETTINGS PROFILE sxt_dashboard_profile
    SETTINGS max_execution_time = 60 CHANGEABLE_IN_READONLY;
```

…and revert it after the backfill is done.

### `failed to create ClickHouse client` in Grafana logs

Either the `sxt_dashboard` user does not exist in ClickHouse (the
init.sql aborted halfway), or the password in `.env` no longer matches.
Re-render and re-apply:

```bash
./start.sh render
docker compose exec -T clickhouse clickhouse-client \
    --user "$(grep ^CLICKHOUSE_USER= .env | cut -d= -f2-)" \
    --password "$(grep ^CLICKHOUSE_PASSWORD= .env | cut -d= -f2-)" \
    --multiquery < clickhouse/init.sql
docker compose restart grafana
```

### Backfill takes longer than expected per era

The public RPC is load-balanced across multiple backend nodes, and
round-trip latency varies.  `backfill.py` retries with backoff when it
sees inconsistent responses.  Roughly one minute per era is normal under
contention.

If you operate your own archive node, point the backfill there:

```bash
SXT_BACKFILL_RPC=ws://<your_archive>:9944 \
    docker compose exec -e SXT_BACKFILL_RPC sxt-exporter \
    python3 /app/scripts/backfill.py all --force
```

…cuts the total run from ~80 min to ~15.

### Exporter stops updating SXT-namespace metrics after a while

If you see panels such as `Block heights`, `Peers over time` or `Finality lag`
freezing on a stale value while other panels keep moving, the custom exporter
has lost its WebSocket session against the Substrate RPC.

This is almost always caused by `SXT_RPC_URL` pointing at a public RPC
(e.g. `https://rpc.mainnet.sxt.network`).  Public endpoints are load-balanced
across multiple backend nodes and close idle WebSockets aggressively, which
breaks the long-lived connection used by `substrate-interface`.

The fix is to point the exporter at **your own node**:

```bash
# in .env on the dashboard host
SXT_RPC_URL=http://<your_validator_ip>:9944
```

…and make sure your validator's firewall allows TCP/9944 from the dashboard
host.  Then recreate the exporter:

```bash
docker compose up -d --force-recreate sxt-exporter
```

The exporter is also resilient by design: after `SXT_RECONNECT_AFTER_FAILURES`
consecutive failures it forces a fresh WebSocket connection and applies an
exponential backoff (`SXT_MAX_BACKOFF_SECONDS` cap).  If `/health` reports a
stale collection beyond `SXT_STALE_HEALTH_SECONDS`, the docker healthcheck
returns 503 and the container is restarted by the `restart: unless-stopped`
policy.

### Validator name validation says my validator is not in the staking API

The installer fetches `https://staking.spaceandtime.io/api/validator` and
looks for an exact (case-sensitive) match.  Edge cases:

- API unreachable: warn-and-continue.  You can use any name; just be sure
  it matches what the chain reports.
- Typo in your validator's display name: the installer suggests the three
  closest matches.  Pick one and re-run.
- Validator newly registered and not yet indexed: use the name and continue;
  it will resolve on the next API refresh.

---

## License

Released under the [MIT License](LICENSE).
