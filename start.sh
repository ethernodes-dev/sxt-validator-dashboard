#!/usr/bin/env bash
#===============================================================================
# SXT Validator Dashboard — start script
#
# Daily-use wrapper around docker compose.  Renders the three templates
# (prometheus.yml, init.sql, sxt-validator.json) from .env values, then
# performs the requested action.
#
# Usage:  ./start.sh [up|down|restart|logs|status|render]
#
# First-time setup is done by ./install.sh — it generates a working .env.
#
# We deliberately do NOT `source .env` because shell sourcing interpolates
# $foo references inside values, which mangles passwords containing $.
# Instead, Python reads the file with a literal parser, and docker compose
# reads the file natively (which is also non-interpolating).  Anything the
# shell itself needs (a couple of port numbers for curl in `status`) is
# pulled out via the same Python parser.
#===============================================================================
set -euo pipefail
cd "$(dirname "$0")"

if [ ! -f .env ]; then
    echo "ERROR: .env not found.  Run ./install.sh first."
    exit 1
fi

# -----------------------------------------------------------------------------
# Helper: read a single key from .env as a literal value (no interpolation).
# Lines starting with #, blanks, and missing keys produce an empty result.
# Keys are looked up exactly; first match wins.
# -----------------------------------------------------------------------------
env_get() {
    local key="$1"
    python3 - "$key" <<'PYEOF'
import sys
key = sys.argv[1]
try:
    with open(".env", "r", encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line or line.lstrip().startswith("#"):
                continue
            if "=" not in line:
                continue
            k, _, v = line.partition("=")
            if k.strip() == key:
                # Strip surrounding quotes if present, otherwise use raw.
                v = v.strip()
                if (len(v) >= 2 and ((v[0] == v[-1] == '"') or (v[0] == v[-1] == "'"))):
                    v = v[1:-1]
                print(v, end="")
                sys.exit(0)
except FileNotFoundError:
    pass
# Not found: print nothing, exit 0.
PYEOF
}

# -----------------------------------------------------------------------------
# Render templates
#
# All substitution is done in a single Python process that reads .env
# directly (no shell interpolation).  Failure modes:
#   - missing required env var          -> exit 2
#   - placeholder still present after    -> exit 2  (means we forgot one)
#   - rendered dashboard JSON invalid    -> exit 2
# -----------------------------------------------------------------------------
echo "Rendering templates from .env..."

python3 - <<'PYEOF'
import json, os, sys

# .env loader (literal, no interpolation)
def load_env(path=".env"):
    out = {}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line or line.lstrip().startswith("#"):
                continue
            if "=" not in line:
                continue
            k, _, v = line.partition("=")
            k = k.strip()
            v = v.strip()
            if len(v) >= 2 and ((v[0] == v[-1] == '"') or (v[0] == v[-1] == "'")):
                v = v[1:-1]
            out[k] = v
    return out

env = load_env()

# placeholder -> env var
SUBSTITUTIONS = {
    "__SXT_PROMETHEUS_TARGET__":      "SXT_PROMETHEUS_TARGET",
    "__SXT_EXPORTER_PORT__":          "SXT_EXPORTER_PORT",
    "__NODE_EXPORTER_TARGET__":       "NODE_EXPORTER_TARGET",
    "__PROMETHEUS_SCRAPE_INTERVAL__": "PROMETHEUS_SCRAPE_INTERVAL",
    "__SXT_DASHBOARD_PASSWORD__":     "SXT_DASHBOARD_PASSWORD",
    "__SXT_LOCAL_VALIDATOR__":        "SXT_LOCAL_VALIDATOR",
    "__SXT_DATA_MOUNTPOINT__":        "SXT_DATA_MOUNTPOINT",
}

TEMPLATES = [
    ("prometheus/prometheus.yml.tpl",                "prometheus/prometheus.yml"),
    ("clickhouse/init.sql.tpl",                      "clickhouse/init.sql"),
    ("grafana/dashboards/sxt-validator.json.tpl",    "grafana/dashboards/sxt-validator.json"),
]

# Verify all required env vars are present and non-empty BEFORE we render.
missing = [v for v in set(SUBSTITUTIONS.values()) if not env.get(v)]
if missing:
    print("ERROR: required .env variables are missing or empty:", file=sys.stderr)
    for m in sorted(missing):
        print(f"  - {m}", file=sys.stderr)
    sys.exit(2)

for src, dst in TEMPLATES:
    if not os.path.exists(src):
        print(f"ERROR: template not found: {src}", file=sys.stderr)
        sys.exit(2)
    with open(src, "r", encoding="utf-8") as f:
        content = f.read()
    for placeholder, env_name in SUBSTITUTIONS.items():
        content = content.replace(placeholder, env[env_name])
    # Sanity: no SUBSTITUTIONS placeholder remains.
    leftovers = [p for p in SUBSTITUTIONS if p in content]
    if leftovers:
        print(f"ERROR: placeholder(s) {leftovers} still present in {dst}",
              file=sys.stderr)
        sys.exit(2)
    with open(dst, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  rendered: {dst}")

# Final integrity check on the dashboard JSON.
with open("grafana/dashboards/sxt-validator.json", "r", encoding="utf-8") as f:
    json.load(f)
print("  dashboard JSON: valid")
PYEOF

# Echo a one-line summary using values pulled from .env (no shell interp).
echo "  validator:        $(env_get SXT_LOCAL_VALIDATOR)"
echo "  SXT node metrics: $(env_get SXT_PROMETHEUS_TARGET)"
echo "  SXT exporter:     sxt-exporter:$(env_get SXT_EXPORTER_PORT)"
echo "  Node exporter:    $(env_get NODE_EXPORTER_TARGET)"
echo "  Disk mountpoint:  $(env_get SXT_DATA_MOUNTPOINT)"
echo

# -----------------------------------------------------------------------------
# Action
# -----------------------------------------------------------------------------
ACTION="${1:-up}"

# Pull a couple of values for the local curl checks.  These have safe
# defaults documented in .env.example, so they are unlikely to contain $.
GRAFANA_PORT="$(env_get GRAFANA_PORT)";       GRAFANA_PORT="${GRAFANA_PORT:-3000}"
PROMETHEUS_PORT="$(env_get PROMETHEUS_PORT)"; PROMETHEUS_PORT="${PROMETHEUS_PORT:-9090}"
SXT_EXPORTER_PORT="$(env_get SXT_EXPORTER_PORT)"; SXT_EXPORTER_PORT="${SXT_EXPORTER_PORT:-9101}"
GRAFANA_ADMIN_USER="$(env_get GRAFANA_ADMIN_USER)"; GRAFANA_ADMIN_USER="${GRAFANA_ADMIN_USER:-admin}"

case "$ACTION" in
    up)
        echo "Starting SXT Validator Dashboard..."
        docker compose up -d --build
        echo
        echo "Dashboard ready at http://localhost:${GRAFANA_PORT}"
        echo "  User: ${GRAFANA_ADMIN_USER}"
        echo "  Pass: (set in .env, not echoed)"
        ;;
    down)
        echo "Stopping SXT Validator Dashboard..."
        docker compose down
        ;;
    restart)
        echo "Restarting SXT Validator Dashboard..."
        docker compose down
        docker compose up -d --build
        ;;
    logs)
        docker compose logs -f "${2:-}"
        ;;
    render)
        # Already done above — exit cleanly.
        ;;
    status)
        echo "=== Container status ==="
        docker compose ps
        echo
        echo "=== Prometheus targets ==="
        if curl -sf "http://localhost:${PROMETHEUS_PORT}/api/v1/targets" \
             > /tmp/.sxt_targets 2>/dev/null
        then
            python3 - <<'PYEOF'
import json
with open("/tmp/.sxt_targets") as f:
    data = json.load(f)
for t in data.get("data", {}).get("activeTargets", []):
    job = t["labels"].get("job", "?")
    print(f"  {job:20s} {t['health']:7s} {t['scrapeUrl']}")
PYEOF
            rm -f /tmp/.sxt_targets
        else
            echo "  (Prometheus not reachable on :${PROMETHEUS_PORT})"
        fi
        echo
        echo "=== Exporter health ==="
        if curl -sf "http://localhost:${SXT_EXPORTER_PORT}/health" >/dev/null 2>&1; then
            echo "  Exporter OK"
        else
            echo "  Exporter not reachable on :${SXT_EXPORTER_PORT}"
        fi
        ;;
    *)
        echo "Usage: $0 [up|down|restart|logs|status|render]"
        exit 1
        ;;
esac
