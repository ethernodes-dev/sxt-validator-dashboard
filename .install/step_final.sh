#!/usr/bin/env bash
step_final() {
    step "All done"

    local url
    if [ "$GRAFANA_BIND" = "0.0.0.0" ]; then
        url="http://<this-host>:${GRAFANA_PORT}"
    else
        url="http://localhost:${GRAFANA_PORT}"
    fi

    printf '\n'
    printf '  Dashboard\n'
    printf '    URL          : %s\n' "$url"
    printf '    Admin user   : %s\n' "${GRAFANA_ADMIN_USER:-admin}"
    printf '    Admin pass   : (stored in .env, mode 600)\n'
    if [ "$GRAFANA_BIND" = "127.0.0.1" ]; then
        printf '\n'
        printf '    From your laptop, open an SSH tunnel:\n'
        printf '        ssh -L %s:127.0.0.1:%s <user>@<this-host>\n' "$GRAFANA_PORT" "$GRAFANA_PORT"
    fi
    printf '\n'
    printf '  Day-to-day commands\n'
    printf '    ./start.sh status     — check container + target health\n'
    printf '    ./start.sh logs       — follow all logs\n'
    printf '    ./start.sh restart    — restart the stack\n'
    printf '    ./start.sh down       — stop everything (data preserved)\n'
    printf '\n'
    printf '  Where things live\n'
    printf '    .env                  — your secrets and config\n'
    printf '    install.log           — record of this installation\n'
    printf '    backfill.log          — backfill progress (if launched)\n'
    printf '\n'
    printf '  Welcome to the network.\n'
    printf '\n'
    return 0
}
