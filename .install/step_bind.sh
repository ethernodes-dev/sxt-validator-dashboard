#!/usr/bin/env bash
step_bind() {
    step "Grafana network exposure"
    info "By default the dashboard listens only on 127.0.0.1.  Access it via"
    info "SSH tunnel or via a reverse proxy with TLS in front.  Recommended."
    info ""
    info "If you bind to 0.0.0.0 the dashboard is reachable from the public"
    info "internet on port ${GRAFANA_PORT:-3000} without TLS.  Bots will probe"
    info "within hours."
    info ""

    # If GRAFANA_BIND is preset (env var), keep it.
    if [ -n "${GRAFANA_BIND:-}" ]; then
        ok "GRAFANA_BIND preset to: $GRAFANA_BIND"
        return 0
    fi

    if ask_yn "Bind Grafana to 127.0.0.1 only? (recommended)" "y"; then
        GRAFANA_BIND="127.0.0.1"
        ok "Grafana will bind to 127.0.0.1:${GRAFANA_PORT}."
        info ""
        info "To reach it from your laptop, open an SSH tunnel:"
        info "    ssh -L ${GRAFANA_PORT}:127.0.0.1:${GRAFANA_PORT} <user>@<this-host>"
    else
        warn "You chose to expose Grafana on 0.0.0.0:${GRAFANA_PORT}."
        warn "This is INSECURE without a reverse proxy + TLS."
        if ! ask_yn "Are you sure?" "n"; then
            GRAFANA_BIND="127.0.0.1"
            ok "Reverted to 127.0.0.1."
        else
            GRAFANA_BIND="0.0.0.0"
            warn "Grafana will bind to 0.0.0.0 — set up a firewall rule."
        fi
    fi
    return 0
}
