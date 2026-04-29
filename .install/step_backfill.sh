#!/usr/bin/env bash
step_backfill() {
    step "Historical backfill"
    info "Walks the last 80 eras of SXT mainnet (~80 days) and populates"
    info "ClickHouse with rewards, stake snapshots, validator metadata."
    info "Without it, history panels stay empty until the live exporter"
    info "accumulates ~80 days of data naturally."
    info ""
    info "Public RPC: 60–80 minutes.  Private archive: 15–25 minutes."
    info ""

    if ! ask_yn "Run the backfill in background now?" "y"; then
        warn "Skipped.  Launch later with:"
        info ""
        info "    docker compose exec sxt-exporter \\"
        info "        python3 /app/scripts/backfill.py all --force"
        info ""
        info "Use --force because the live exporter writes the current era"
        info "immediately, otherwise backfill exits 'nothing to do'."
        return 0
    fi

    docker compose exec -d sxt-exporter \
        sh -c "python3 /app/scripts/backfill.py all --force >> /tmp/backfill.log 2>&1"

    ok "Backfill running in the background."
    info ""
    info "Follow progress with:"
    info "    docker compose exec sxt-exporter tail -f /tmp/backfill.log"
    info ""
    info "It is safe to close this session — backfill keeps running"
    info "inside the container."
    return 0
}
