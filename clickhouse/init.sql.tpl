-- ============================================================
-- SXT Validator Dashboard — ClickHouse Schema & Access Control
--
-- Runs ONCE on a fresh ClickHouse volume.  If you change anything
-- here on an existing deployment you must apply the changes
-- manually with clickhouse-client; the entrypoint does not re-run.
--
-- Two-user model (recommended by Grafana ClickHouse plugin docs
-- and ClickHouse-Grafana integration docs to prevent SQLi
-- through dashboard panels):
--
--   * sxt_exporter — INSERT + SELECT, used by the Python exporter
--                    and the backfill script.
--   * sxt_dashboard — SELECT only with hard resource limits
--                     (max_memory_usage, max_execution_time,
--                     readonly=1), used by Grafana datasource.
--
-- The entrypoint creates the sxt_exporter user with
-- access_management=1.  This is set via the env var
-- CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 in docker-compose.yml
-- (NOT CLICKHOUSE_ACCESS_MANAGEMENT — the entrypoint only reads
-- the *_DEFAULT_* form, see ClickHouse upstream entrypoint.sh).
-- access_management=1 is what lets this script CREATE SETTINGS
-- PROFILE / CREATE USER / GRANT.
-- ============================================================

CREATE DATABASE IF NOT EXISTS sxt;

-- ------------------------------------------------------------
-- 1. Schema — data tables
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS sxt.price_history (
    timestamp    DateTime64(3, 'UTC'),
    price_usd    Float64,
    price_eur    Float64,
    market_cap_usd Float64,
    volume_24h_usd Float64,
    change_24h_pct Float64
) ENGINE = MergeTree()
ORDER BY timestamp
TTL toDateTime(timestamp) + INTERVAL 2 YEAR;

CREATE TABLE IF NOT EXISTS sxt.era_rewards (
    era              UInt32,
    validator_address String,
    validator_name    String,
    total_stake       Float64,
    own_stake         Float64,
    nominator_count   UInt32,
    commission_pct    Float64,
    era_points        UInt32,
    era_total_points  UInt32,
    era_total_reward  Float64,
    validator_reward  Float64,
    is_active         UInt8,
    timestamp         DateTime64(3, 'UTC')
) ENGINE = ReplacingMergeTree(timestamp)
ORDER BY (era, validator_address)
TTL toDateTime(timestamp) + INTERVAL 2 YEAR;

CREATE TABLE IF NOT EXISTS sxt.era_snapshots (
    era               UInt32,
    total_stake       Float64,
    active_validators UInt32,
    total_nominators  UInt32,
    era_reward        Float64,
    price_usd_at_era  Float64,
    timestamp         DateTime64(3, 'UTC')
) ENGINE = ReplacingMergeTree(timestamp)
ORDER BY era
TTL toDateTime(timestamp) + INTERVAL 2 YEAR;

CREATE TABLE IF NOT EXISTS sxt.delegation_snapshots (
    timestamp          DateTime64(3, 'UTC'),
    era                UInt32,
    validator_address  String,
    validator_name     String,
    total_stake        Float64,
    own_stake          Float64,
    delegated_stake    Float64,
    nominator_count    UInt32,
    stake_change       Float64
) ENGINE = MergeTree()
ORDER BY (timestamp, validator_address)
TTL toDateTime(timestamp) + INTERVAL 2 YEAR;

-- ------------------------------------------------------------
-- 2. Views consumed by Grafana
-- ------------------------------------------------------------

-- v_era_rewards: per-era network metrics.
-- Prefers era_snapshots (filled in real time by the live exporter, includes
-- price_usd_at_era from CoinGecko at scrape time) and falls back to an
-- aggregate of era_rewards for eras that the live exporter never saw —
-- typically backfilled eras where historical price data is not retrievable
-- and the snapshot row does not exist.
CREATE OR REPLACE VIEW sxt.v_era_rewards AS
SELECT
    era,
    network_stake,
    network_reward,
    active_validators,
    total_nominators,
    price_usd
FROM (
    SELECT
        era,
        total_stake       AS network_stake,
        era_reward        AS network_reward,
        active_validators,
        total_nominators,
        price_usd_at_era  AS price_usd,
        1                 AS source_priority   -- snapshots wins
    FROM sxt.era_snapshots FINAL

    UNION ALL

    SELECT
        era,
        sum(total_stake)                 AS network_stake,
        any(era_total_reward)            AS network_reward,
        toUInt32(countIf(is_active = 1)) AS active_validators,
        toUInt32(sum(nominator_count))   AS total_nominators,
        toFloat64(0)                     AS price_usd,
        2                                AS source_priority   -- fallback
    FROM sxt.era_rewards FINAL
    GROUP BY era
)
ORDER BY era ASC, source_priority ASC
LIMIT 1 BY era;

-- v_delegation_changes: per-era inflow / outflow / net delegation change.
-- Computed by lagging total_stake per validator across consecutive eras.
--
-- Design notes:
--   * We do NOT use the stake_change column on delegation_snapshots.
--     That column is only populated by the live exporter (which keeps a
--     per-validator previous-stake cache in RAM) and is always 0 for rows
--     written by the backfill script.  Computing the delta in SQL means
--     historical eras are correct as soon as backfill writes snapshots,
--     with no extra columns and no parallel state to maintain.
--
--   * delegation_snapshots is a plain MergeTree (not Replacing).  Multiple
--     rows can exist for the same (era, validator_address) — typically when
--     the live exporter restarts mid-era, or when backfill writes a row
--     for an era that the live exporter later samples again.  We
--     pre-deduplicate per pair using argMax(total_stake, timestamp) so the
--     window function operates on a clean one-row-per-(era,validator) set.
--
--   * lagInFrame uses (col, 1, NULL) to return NULL for the first era of
--     each validator.  total_stake is wrapped in toNullable() so that the
--     argument type matches the default value type (otherwise ClickHouse
--     rejects the call as a supertype mismatch).  The outer
--     `WHERE delta IS NOT NULL` then drops those bootstrap rows so we do
--     NOT incorrectly count a validator's first-ever stake as an inflow.
CREATE OR REPLACE VIEW sxt.v_delegation_changes AS
SELECT
    era,
    sum(if(delta > 0, delta, 0)) AS inflows,
    sum(if(delta < 0, delta, 0)) AS outflows,
    sum(delta)                   AS net_change
FROM (
    SELECT
        era,
        validator_address,
        total_stake - lagInFrame(toNullable(total_stake), 1, NULL) OVER (
            PARTITION BY validator_address
            ORDER BY era
        ) AS delta
    FROM (
        SELECT
            era,
            validator_address,
            argMax(total_stake, timestamp) AS total_stake
        FROM sxt.delegation_snapshots
        GROUP BY era, validator_address
    )
)
WHERE delta IS NOT NULL AND delta != 0
GROUP BY era
ORDER BY era;

-- Per-era operator earnings (derived from era_rewards).
-- Substrate economics: commission taken first, remainder split
-- by stake proportion.
CREATE OR REPLACE VIEW sxt.v_validator_earnings AS
SELECT
    era,
    validator_name,
    validator_reward * (commission_pct / 100) as commission_sxt,
    if(total_stake > 0,
       (validator_reward - validator_reward * (commission_pct / 100)) * (own_stake / total_stake),
       0) as own_yield_sxt,
    validator_reward * (commission_pct / 100)
      + if(total_stake > 0,
           (validator_reward - validator_reward * (commission_pct / 100)) * (own_stake / total_stake),
           0) as total_earned_sxt,
    validator_reward,
    commission_pct as commission_rate,
    own_stake,
    total_stake - own_stake as delegated_stake,
    total_stake
FROM sxt.era_rewards FINAL
WHERE validator_reward > 0
ORDER BY era;

CREATE OR REPLACE VIEW sxt.v_validator_monthly AS
SELECT
    formatDateTime(toStartOfMonth(toDateTime(timestamp)), '%Y-%m') as month,
    validator_name,
    sum(validator_reward * (commission_pct / 100)) as comm_sxt,
    sum(if(total_stake > 0,
           (validator_reward - validator_reward * (commission_pct / 100)) * (own_stake / total_stake),
           0)) as yield_sxt,
    sum(validator_reward * (commission_pct / 100)
      + if(total_stake > 0,
           (validator_reward - validator_reward * (commission_pct / 100)) * (own_stake / total_stake),
           0)) as total_sxt
FROM sxt.era_rewards FINAL
WHERE validator_reward > 0
GROUP BY month, validator_name
ORDER BY month;

-- ------------------------------------------------------------
-- 3. Settings profiles — bound query resources
-- ------------------------------------------------------------
-- The dashboard profile enforces readonly=1 so a SQL injection
-- through any Grafana panel cannot mutate data.
-- max_execution_time is CHANGEABLE_IN_READONLY because the
-- clickhouse-go client used by the Grafana plugin rewrites that
-- setting per query (Grafana ClickHouse plugin docs).
-- ------------------------------------------------------------

CREATE SETTINGS PROFILE OR REPLACE sxt_dashboard_profile SETTINGS
    max_memory_usage   = 2000000000,
    max_execution_time = 30 CHANGEABLE_IN_READONLY,
    max_result_rows    = 100000,
    max_threads        = 2,
    readonly           = 1;

-- ------------------------------------------------------------
-- 4. Users
-- ------------------------------------------------------------
-- The exporter user (sxt_exporter) is created by the Docker entrypoint
-- via CLICKHOUSE_USER / CLICKHOUSE_PASSWORD and lives in users.xml.
-- It writes to sxt.* tables in a fixed, repo-controlled code path
-- (no external query surface), so it does not carry a resource profile.
-- Profiles in users.xml cannot be set via SQL ALTER (storage is readonly).
--
-- The dashboard user is created here as a SQL-RBAC user with the
-- read-only profile.  Grafana connects with this user, so a SQL
-- injection via any panel cannot mutate data or DoS the database.
-- The literal __SXT_DASHBOARD_PASSWORD__ is rendered by start.sh
-- from .env (SXT_DASHBOARD_PASSWORD) before the file is mounted
-- into the container.
-- ------------------------------------------------------------

CREATE USER OR REPLACE sxt_dashboard
    IDENTIFIED WITH sha256_password BY '__SXT_DASHBOARD_PASSWORD__'
    SETTINGS PROFILE 'sxt_dashboard_profile';

GRANT SELECT ON sxt.* TO sxt_dashboard;
