#!/usr/bin/env bash
# Ask for the SXT node Prometheus endpoint and node_exporter endpoint.

step_endpoints() {
    step "SXT node and host endpoints"

    info "The dashboard scrapes Prometheus metrics from your SXT node and"
    info "from node_exporter (host metrics)."
    info "  - 172.17.0.1 is the Docker bridge gateway, which lets a container"
    info "    reach services running on the host."
    info ""

    local default_host
    default_host="172.17.0.1"

    local sxt_host sxt_port nx_host nx_port
    sxt_host="$(ask "SXT node host (IP or hostname)" "$default_host")"
    sxt_port="$(ask "SXT node Prometheus exporter port" "9615")"

    nx_host="$(ask "Host metrics (node_exporter) host" "$default_host")"
    nx_port="$(ask "node_exporter port" "9100")"

    SXT_PROMETHEUS_TARGET="${sxt_host}:${sxt_port}"
    NODE_EXPORTER_TARGET="${nx_host}:${nx_port}"

    # Friendly conn check (non-fatal)
    info ""
    info "Quick connectivity test..."
    if curl -fsS --max-time 3 "http://${SXT_PROMETHEUS_TARGET}/metrics" \
           >/dev/null 2>&1
    then
        ok "SXT node responds at ${SXT_PROMETHEUS_TARGET}"
    else
        warn "Could not reach ${SXT_PROMETHEUS_TARGET} from this host."
        warn "If the node is on this same machine, this is expected — the"
        warn "  exporter container will reach it via the Docker bridge gateway."
    fi
    if curl -fsS --max-time 3 "http://${NODE_EXPORTER_TARGET}/metrics" \
           >/dev/null 2>&1
    then
        ok "node_exporter responds at ${NODE_EXPORTER_TARGET}"
    else
        warn "Could not reach ${NODE_EXPORTER_TARGET} from this host."
    fi
    return 0
}
