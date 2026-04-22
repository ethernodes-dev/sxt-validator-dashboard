"""
Panel descriptions for SXT Validator Dashboard.

Format per description:
- What it measures (1 sentence)
- Data source (Prometheus metric or ClickHouse table)
- Interpretation / thresholds (when applicable)
- When to worry (when applicable)

Identifiers: panels with titles matched by title, else by first 60 chars of expr.

Special marker: "__KEEP__" means leave existing description untouched.
"""

DESCRIPTIONS = {
    '⬢ Protocol overview': {
        'substrate_block_height{status="best",job="sxt-node"}': """Latest block produced by the network (head of the chain).

Source: substrate_block_height{status='best'} (produced by BABE).
BABE is Substrate's block production mechanism; 'best' blocks can still be reverted in short reorgs until GRANDPA finalizes them.""",

        'substrate_block_height{status="finalized",job="sxt-node"}': """Latest finalized block (irreversible tip confirmed by GRANDPA).

Source: substrate_block_height{status='finalized'} (finalized by GRANDPA).
GRANDPA is Substrate's finality gadget; once ≥2/3 validators vote a block, it and all ancestors become provably final.""",

        'sxt_finality_lag_blocks': """Number of blocks between 'best' (BABE head) and 'finalized' (GRANDPA tip).

Source: sxt_finality_lag_blocks = best_height - finalized_height.
Healthy: 2-3 blocks (normal GRANDPA round). Warn: >5. Danger: >20 (GRANDPA stalling — possible validator connectivity or consensus issue).""",

        'sxt_is_syncing': """Whether the local node is still catching up with the network.

Source: sxt_is_syncing (from system_health.isSyncing RPC).
'Synced' = caught up to best block. 'Syncing' = still importing historical blocks; validation duties must NOT be performed until fully synced.""",

        'sxt_runtime_spec_version': """On-chain runtime specification version.

Source: sxt_runtime_spec_version.
Incremented on runtime upgrades via governance. Mismatch with your client's supported spec can cause block execution failures.""",

        'sxt_pending_extrinsics': """Transactions currently in the local node's transaction pool waiting to be included.

Source: sxt_pending_extrinsics.
Growing pool can indicate network congestion or blocked propagation.""",

        'sxt_staking_current_era': """Current staking era number.

Source: sxt_staking_current_era.
An era is the unit of time over which nominators and validators earn rewards. Eras roll over automatically based on session lengths defined by governance.""",

        'sxt_network_babe_epoch_index': """Current BABE epoch index.

Source: sxt_network_babe_epoch_index.
BABE epochs are the unit of validator rotation for block production duties. Shorter than eras; multiple epochs make up one era.""",

        'sxt_grandpa_round': """Current GRANDPA finality voting round.

Source: sxt_grandpa_round.
A round is one attempt by validators to finalize a set of blocks via pre-vote + pre-commit. Increments on every successful finalization.""",

        'sxt_staking_era_progress * 100': """Progress through the current staking era, 0-100%.

Source: sxt_staking_era_progress × 100.
At 100%, the era closes and rewards are distributed; a new era starts.""",

        'sxt_network_babe_epoch_progress * 100': """Progress through the current BABE epoch, 0-100%.

Source: sxt_network_babe_epoch_progress × 100.
Shorter cycle than eras; used for rotating block authorship duties.""",

    },

    '⬢ Network economics': {
        'sxt_token_price_usd': """Current SXT token price in USD.

Source: sxt_token_price_usd (CoinGecko free API, scraped every 5m)
Used as multiplier across all USD conversions in the dashboard.""",

        'sxt_token_price_change_24h_pct': """24-hour price change in percent.

Source: sxt_token_price_change_24h_pct (CoinGecko)
Green when positive, red when negative.""",

        'sxt_token_market_cap_usd': """Total market capitalization of SXT in USD.

Source: sxt_token_market_cap_usd (CoinGecko)
Calculated as circulating supply × current price.""",

        'sxt_token_volume_24h_usd': """24-hour trading volume across all exchanges, in USD.

Source: sxt_token_volume_24h_usd (CoinGecko)
Liquidity indicator: low volume can signal exit difficulty.""",

        'sxt_staking_era_total_stake_usd': """Total stake bonded in the current staking era, expressed in USD.

Source: sxt_staking_era_total_stake * current price
Proxy for total capital secured by SXT's consensus.""",

        'sxt_staking_last_era_reward_usd': """Total rewards distributed in the last completed era, in USD.

Source: sxt_staking_last_era_reward * current price
Era rewards are minted and split across active validators by era points.""",

        'SELECT timestamp as time, price_usd FROM sxt.price_history': "__KEEP__",
    },

    '⬢ Validators — global stats': {
        'sxt_network_active_validators': """Number of validators currently producing blocks in the active set.

Source: sxt_network_active_validators
Bounded above by the target validator count (see Max validators card).""",

        'sxt_staking_waiting_validators': """Validators registered and bonded but not in the active set.

Source: sxt_staking_waiting_validators
They compete by stake weight for active slots each era.""",

        'sxt_staking_total_nominators': """Total number of unique nominator accounts delegating to validators.

Source: sxt_staking_total_nominators
Higher count = wider stake distribution = healthier decentralisation.""",

        'sxt_staking_era_total_stake': """Total SXT bonded for consensus in the current era.

Source: sxt_staking_era_total_stake
Sum of all nominators' stake across all active validators.""",

        'sxt_staking_last_era_reward': """Reward pool distributed in the last completed era, in SXT.

Source: sxt_staking_last_era_reward
Split across validators proportionally to era points earned.""",

        'sxt_staking_era_total_reward_points': """Total era points generated network-wide in the current era.

Source: sxt_staking_era_total_reward_points
Era points are earned by block authorship and validation duties.""",

        'sxt_staking_target_validator_count': """Target size of the active validator set, defined by governance.

Source: sxt_staking_target_validator_count
Currently 18. Validators above this count are pushed to the waiting pool.""",

        'Stake per validator': """Treemap showing each validator's total stake as a tile, sized by SXT bonded.

Source: sxt_validator_total_stake{address=...}
Visual check for stake concentration.""",

        'Era points per validator': """Horizontal bar ranking showing era points earned so far in the current era.

Source: sxt_validator_era_points{address=...}
Validators below the network average may be under-performing.""",

        'All validators': "__KEEP__",
        'Stake distribution': """Pie/donut showing relative stake share per validator in USD terms.

Source: sxt_validator_total_stake_usd
Nakamoto coefficient quick-view: how many top validators control >33%.""",

        'Era rewards history': """Historical SXT rewards distributed per era across the entire network.

Source: sxt.v_era_rewards (ClickHouse view, computed from ErasValidatorReward).
Steady = healthy network inflation; drops indicate missed rewards.""",

        'Delegation changes': """Per-era nominator flows: inflows (new delegations), outflows (undelegations), net change.

Source: sxt.v_delegation_changes (ClickHouse view)
Useful for tracking user trust trends in the staking pool.""",

    },

    '⬢ Validator economics': {
        'Estimated APR per validator': """Estimated annual percentage return for each validator, based on recent era rewards.

Source: sxt_validator_estimated_apr
Computed from last era reward, scaled to a year. Subject to commission and uptime.""",

        'Stake per validator over time': """Time-series view of each validator's total stake (SXT) evolution.

Source: sxt_validator_total_stake, range query
Growth trends, slashing events, or nominator exits become visible here.""",

        '★ Latest era reward': """Estimated reward for this validator in the current era, in SXT.

Source: sxt_validator_estimated_era_reward{address=${validator}}
Extrapolated from era points accrued so far. Finalizes at era end.""",

        '★ APR': """Annualized percentage return for this validator, net of commission.

Source: sxt_validator_estimated_apr{address=${validator}}
Estimate only — actual yield depends on uptime and era point performance.""",

        '★ 84-day commission': """Total commission earned over the last 84 eras (~21 days at 6h/era).

Source: sxt.v_validator_earnings (ClickHouse view, sum of commission_sxt)
Reflects revenue collected from nominators' rewards.""",

        '★ 84-day total earned': """Total rewards (commission + own yield) for the validator over the last 84 eras.

Source: sxt.v_validator_earnings (sum of total_earned_sxt)
Gross income before operational costs.""",

        '★ Monthly commission': """Commission earned in the current calendar month, in SXT.

Source: sxt.v_validator_monthly (ClickHouse view)
Reset at the start of each month; compare across months in the bar chart below.""",

        '★ Monthly own yield': """Own-stake yield (non-commission portion) for the current month, in SXT.

Source: sxt.v_validator_monthly (yield_sxt column)
Proportional to the validator's own bonded stake.""",

        '★ Monthly total': """Sum of commission + own yield for the current month, in SXT.

Source: sxt.v_validator_monthly (total_sxt column)
Primary top-line monthly revenue figure.""",

        '★ Monthly total (USD)': """Monthly total SXT earnings converted to USD at current price.

Source: sxt.v_validator_monthly.total_sxt × sxt.price_history (latest)
Volatile with SXT price; the SXT-denominated figure is more stable.""",

        'Earnings per era': """Per-era breakdown of commission and own yield, in SXT and USD.

Source: sxt.v_validator_earnings (84 most recent eras)
Dual Y axis: SXT on left, USD on right. Gradients bars by series.""",

        'Monthly earnings': """Monthly aggregates of commission and own yield.

Source: sxt.v_validator_monthly
Useful for tax/bookkeeping. Select Earnings view (SXT / USD / combined) via toolbar.""",

        '★ Total stake over time': """Per-era snapshot of the validator's total stake, in SXT.

Source: sxt.delegation_snapshots (ClickHouse, argMax by timestamp per era)
Nominator inflow/outflow materializes here as slope changes.""",

    },

    '⬢ This validator': {
        'Validator status': """Whether this validator is currently in the active set and producing blocks.

Source: sxt_validator_active{address=${local_validator}}
Green 'ACTIVE' = producing. Amber 'WAITING' = bonded but outside the active set.""",

        'Sync status': """Whether the local SXT node has caught up with the network's best block.

Source: sxt_is_syncing (system_health.isSyncing RPC)
Green 'SYNCED' required for correct validation. Amber 'SYNCING' during catch-up.""",

        'RPC status': """Whether the node's JSON-RPC endpoint is reachable by the exporter.

Source: sxt_rpc_up (1 = reachable, 0 = down)
Red 'OFFLINE' blocks metric collection. Check systemd and port 9944 locally.""",

        'Peers': """Count of peers currently connected to the local node.

Source: sxt_peers_count
Healthy range: 20-50. Below 10 risks missed blocks; above 80 strains the connection pool.""",

        'Total stake (SXT)': """Total SXT bonded to this validator (own stake + nominators).

Source: sxt_validator_total_stake{address=${local_validator}}
Determines election priority and reward share within the active set.""",

        'Total stake (USD)': """Total stake converted to USD at the current SXT price.

Source: total_stake × sxt_token_price_usd (cross-metric)
USD figure for reports; SXT-denominated is more stable.""",

        'Own stake': """Validator's self-bonded stake, in SXT.

Source: sxt_validator_own_stake{address=${local_validator}}
Own stake earns yield at full rate (no commission deducted).""",

        'Nominators': """Number of unique nominator accounts delegating to this validator.

Source: sxt_validator_nominator_count{address=${local_validator}}
Higher count = wider trust base.""",

        'Commission rate': """Validator's commission percentage, deducted from nominators' rewards.

Source: sxt_validator_commission{address=${local_validator}}
SXT network enforces a minimum of 10%.""",

        'Era points vs avg': """Era points earned by this validator as % of the network average for the current era.

Source: era_points / scalar(total_era_points / target_validator_count) × 100
Healthy ≥95%. Below 85% suggests missed authorship opportunities or slow propagation.""",

        'Block heights': """Best vs finalized block height on the local node, plotted over time.

Source: sxt_block_height_best (BABE) and sxt_block_height_finalized (GRANDPA).
The two lines should track closely with a small constant gap. If 'finalized' flatlines while 'best' keeps climbing, GRANDPA is stalling.""",

        'Finality lag': """Number of blocks between local 'best' (BABE) and 'finalized' (GRANDPA) tip.

Source: sxt_finality_lag_blocks.
Healthy: 2-3 blocks. Spikes above 10 suggest GRANDPA round failures, peer issues, or this validator not voting in the current round.""",

        'Peers over time': """Breakdown of peers connected to the local node over time.

Source: sxt_peers_count / authority / full / lagging.
'Authority' peers are other active validators (most relevant for consensus). 'Lagging' = peers still syncing that we're helping.""",

        'Block proposal time': """Time the local node takes to construct a new block (average and p99).

Source: substrate_proposer_block_proposal_time_* histogram.
Healthy: <500ms average. Slow proposals risk missing BABE slots and earning fewer era points.""",

        'Block import time': """Time to verify and import a block received from peers (average and p99).

Source: substrate_block_verification_and_import_time_* histogram.
Healthy: <1s average. Slow imports indicate CPU or disk I/O bottlenecks; can cause the node to fall behind consensus.""",

        'Network bandwidth': """Inbound and outbound libp2p traffic at the substrate node process level.

Source: rate(substrate_sub_libp2p_network_bytes_total[5m]).
This is the node's process-level traffic; compare with Host machine → Network I/O for host-wide context.""",

    },

    '⬢ Host machine': {
        'Host status': """Whether node_exporter is reachable by Prometheus on the host.

Source: up{instance='sxt-validator-host',job='node-exporter'}
Red 'DOWN' means the entire host-level monitoring is blind.""",

        'Disk health': """Used-space health on /sxt-data (the validator DB partition).

Source: (1 - avail / size) × 100 on mountpoint='/sxt-data'
Green <80%, amber 80-90%, red ≥90%. Critical at 95% (risk of DB halt).""",

        'Memory health': """Memory pressure health on the host.

Source: (1 - MemAvailable / MemTotal) × 100
Green <80%, amber 80-90%, red ≥90%. Includes cache/buffers as 'available'.""",

        'Load health': """System load normalized per CPU core.

Source: node_load1 / scalar(cpu_count)
Green <1 (CPUs idle enough), amber 1-2 (saturation), red ≥2 (overload).""",

        'CPU usage': """Current CPU utilization across all cores.

Source: (1 - avg rate of mode='idle') × 100
Substrate nodes typically sit at 5-20%. Sustained >70% warrants investigation.""",

        'RAM used': """RAM utilization as percent of total.

Source: (1 - MemAvailable / MemTotal) × 100
Linux aggressively caches filesystem data; 50-70% steady is normal.""",

        'Disk used': """Used space on /sxt-data as percent of the partition.

Source: (1 - avail / size) × 100 on mountpoint='/sxt-data'
Chain state grows continuously. Plan pruning or expansion at 85%.""",

        'Network RX': """Inbound network traffic across physical NICs.

Source: sum of rate(node_network_receive_bytes_total{device=~'enp.*'}) over 1m
Mostly p2p gossip and block propagation. Spikes can correlate with reorgs.""",

        'Network TX': """Outbound network traffic across physical NICs.

Source: sum of rate(node_network_transmit_bytes_total{device=~'enp.*'}) over 1m
Higher for active authorities (broadcasting blocks + GRANDPA votes).""",

        'Uptime': """Time since last host boot.

Source: time() - node_boot_time_seconds
Long uptimes are good for availability metrics but kernel updates eventually require reboot.""",

        'CPU cores': """Number of logical CPU cores on the host.

Source: count of unique 'cpu' labels in node_cpu_seconds_total
Includes hyperthreaded siblings if present.""",

        'RAM total': """Total installed RAM in the host.

Source: node_memory_MemTotal_bytes / 1 GiB
Substrate nodes benefit from 32+ GB; 64 GB is comfortable for validators.""",

        'Disk total': """Total capacity of /sxt-data partition.

Source: node_filesystem_size_bytes{mountpoint='/sxt-data'} / 1 GiB
Planning figure for chain growth estimates.""",

        'CPU temp': """Average CPU temperature across hwmon sensors.

Source: avg of node_hwmon_temp_celsius
Green <70°C, amber 70-85°C, red ≥85°C (thermal throttling risk).""",

        'CPU over time': "__KEEP__",
        'Memory over time': "__KEEP__",
        'Load average': "__KEEP__",
        'Disk I/O': "__KEEP__",
        'Network I/O': "__KEEP__",
    },

}
