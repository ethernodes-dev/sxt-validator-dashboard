#!/usr/bin/env bash
# Pick host ports for Grafana, Prometheus, ClickHouse HTTP/native, exporter.
# Starts from defaults; on collision, suggests next free port.

step_ports() {
    step "Host ports"

    info "Default ports: Grafana 3000, Prometheus 9090, ClickHouse 8123/9000,"
    info "exporter 9101.  If any are taken on this host, the installer will"
    info "suggest the next free port."

    declare -A defaults=(
        [GRAFANA_PORT]=3000
        [PROMETHEUS_PORT]=9090
        [CLICKHOUSE_HTTP_PORT]=8123
        [CLICKHOUSE_NATIVE_PORT]=9000
        [SXT_EXPORTER_PORT]=9101
    )

    # Need stable iteration order, so list the keys explicitly.
    local keys=(GRAFANA_PORT PROMETHEUS_PORT CLICKHOUSE_HTTP_PORT CLICKHOUSE_NATIVE_PORT SXT_EXPORTER_PORT)
    local key def chosen suggested preset
    for key in "${keys[@]}"; do
        def="${defaults[$key]}"
        # Honour env-var presets (e.g. CI passing custom ports).
        preset="$(eval echo "\${$key:-}")"
        if [ -n "$preset" ]; then
            if port_in_use "$preset"; then
                error "$key=$preset (preset) is in use on this host."
                return 1
            fi
            chosen="$preset"
            ok "$key = $chosen (from env)"
            eval "$key=\"$chosen\""
            continue
        fi
        if port_in_use "$def"; then
            suggested="$(find_free_port $((def + 1)))"
            warn "Port $def is in use."
            chosen="$(ask "Replacement for $key" "$suggested")"
        else
            chosen="$(ask "$key" "$def")"
        fi
        # Validate that the answer is a number and not in use.
        if ! [[ "$chosen" =~ ^[0-9]+$ ]] || [ "$chosen" -lt 1 ] || [ "$chosen" -gt 65535 ]; then
            error "Invalid port: $chosen"
            return 1
        fi
        if port_in_use "$chosen"; then
            error "Port $chosen is in use, please pick another."
            return 1
        fi
        # Set the variable
        eval "$key=\"$chosen\""
        ok "$key = $chosen"
    done
    return 0
}
