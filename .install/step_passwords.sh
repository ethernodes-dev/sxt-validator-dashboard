#!/usr/bin/env bash
step_passwords() {
    step "Credentials"
    info "Generating strong random passwords for:"
    info "    - ClickHouse exporter user (sxt_exporter)"
    info "    - ClickHouse dashboard user (sxt_dashboard, read-only)"
    info "    - Grafana admin"
    info ""

    CLICKHOUSE_PASSWORD="$(gen_password)"
    SXT_DASHBOARD_PASSWORD="$(gen_password)"
    GRAFANA_ADMIN_PASSWORD="$(gen_password)"

    if [ -z "$CLICKHOUSE_PASSWORD" ] || [ -z "$SXT_DASHBOARD_PASSWORD" ] || [ -z "$GRAFANA_ADMIN_PASSWORD" ]; then
        error "Failed to generate passwords."
        return 1
    fi

    ok "ClickHouse exporter:   $(mask_password "$CLICKHOUSE_PASSWORD")"
    ok "ClickHouse dashboard:  $(mask_password "$SXT_DASHBOARD_PASSWORD")"
    ok "Grafana admin:         $(mask_password "$GRAFANA_ADMIN_PASSWORD")"
    info ""
    info "Full values are written only to .env (file mode 600)."
    return 0
}
