#!/usr/bin/env bash
step_render() {
    step "Rendering configuration templates"
    if ! ./start.sh render >/dev/null 2>&1; then
        error "Template render failed."
        info  "Re-running with full output:"
        ./start.sh render || true
        return 1
    fi
    local leftover
    leftover="$(grep -lE "__[A-Z_]+__" \
        prometheus/prometheus.yml \
        clickhouse/init.sql \
        grafana/dashboards/sxt-validator.json 2>/dev/null || true)"
    if [ -n "$leftover" ]; then
        error "Placeholders still present:"
        printf '%s\n' "$leftover"
        return 1
    fi
    ok "All templates rendered."
    return 0
}
