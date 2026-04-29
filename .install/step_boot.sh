#!/usr/bin/env bash
step_boot() {
    step "Building images and starting the stack"
    info "First run takes 1–2 minutes (plugin downloads)."
    info ""

    if ! docker compose up -d --build 2>&1 | tail -20; then
        error "docker compose up failed."
        return 1
    fi

    info ""
    info "Waiting for services to become healthy (up to 90s)..."

    local i ok_ch ok_ex ok_gf
    for i in $(seq 1 18); do
        sleep 5
        ok_ch="$(docker compose ps --format '{{.Service}}|{{.Health}}' 2>/dev/null \
            | awk -F'|' '$1=="clickhouse" && $2=="healthy"' | head -1)"
        ok_ex="$(docker compose ps --format '{{.Service}}|{{.Health}}' 2>/dev/null \
            | awk -F'|' '$1=="sxt-exporter" && $2=="healthy"' | head -1)"
        ok_gf="$(curl -fsS --max-time 2 "http://127.0.0.1:${GRAFANA_PORT}/api/health" 2>/dev/null \
            | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('database',''))" 2>/dev/null)"
        printf '    [%2d/18]  ch=%s  exporter=%s  grafana=%s\n' "$i" \
            "$([ -n "$ok_ch" ] && echo healthy || echo waiting)" \
            "$([ -n "$ok_ex" ] && echo healthy || echo waiting)" \
            "$([ "$ok_gf" = "ok" ] && echo healthy || echo waiting)"
        if [ -n "$ok_ch" ] && [ -n "$ok_ex" ] && [ "$ok_gf" = "ok" ]; then
            ok "All services healthy."
            return 0
        fi
    done
    warn "Timed out waiting for full health.  Stack may still be coming up."
    info "Check with: docker compose ps && docker compose logs <service>"
    return 0
}
