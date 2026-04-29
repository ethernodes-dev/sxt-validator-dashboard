#!/usr/bin/env bash
# Fetch validator names from the public staking API and validate the
# operator's choice.  If the API is unreachable, warns but does not abort.

STAKING_API_URL="${STAKING_API_URL:-https://staking.spaceandtime.io/api/validator}"

# Returns 0 if curl succeeded and we have a list of validators.
# Populates the global STAKING_VALIDATOR_NAMES (newline-separated).
fetch_staking_validators() {
    local raw
    if ! raw="$(curl -fsS --max-time 10 "$STAKING_API_URL" 2>/dev/null)"; then
        warn "Could not reach staking API at $STAKING_API_URL"
        warn "Validator-name validation will be skipped."
        STAKING_VALIDATOR_NAMES=""
        return 1
    fi

    STAKING_VALIDATOR_NAMES="$(printf '%s' "$raw" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception as e:
    print(f"PARSE_ERROR: {e}", file=sys.stderr)
    sys.exit(2)
names = []
# Accept both list-of-objects and {validators: [...]}
if isinstance(data, dict):
    for k in ("validators", "data", "items"):
        if k in data and isinstance(data[k], list):
            data = data[k]; break
if isinstance(data, list):
    for v in data:
        if isinstance(v, dict):
            n = v.get("name") or v.get("validator_name") or v.get("display")
            if n: names.append(str(n))
        elif isinstance(v, str):
            names.append(v)
print("\n".join(sorted(set(names))))
' 2>/dev/null)" || {
        warn "Could not parse staking API response."
        STAKING_VALIDATOR_NAMES=""
        return 1
    }

    local n
    n="$(printf '%s' "$STAKING_VALIDATOR_NAMES" | grep -c '.' || true)"
    if [ "$n" -eq 0 ]; then
        warn "Staking API returned an empty list."
        return 1
    fi
    return 0
}

# Validate an exact name match.
# Returns 0 if it matches exactly, 1 otherwise.
validator_name_exists() {
    local name="$1"
    [ -z "$STAKING_VALIDATOR_NAMES" ] && return 0  # API unreachable, accept
    printf '%s\n' "$STAKING_VALIDATOR_NAMES" | grep -Fxq -- "$name"
}

# Suggest the 3 closest matches to a misspelled name.
suggest_validator_names() {
    local name="$1"
    [ -z "$STAKING_VALIDATOR_NAMES" ] && return
    printf '%s\n' "$STAKING_VALIDATOR_NAMES" | python3 -c "
import sys, difflib
target = '$name'
names = [l.strip() for l in sys.stdin if l.strip()]
matches = difflib.get_close_matches(target, names, n=3, cutoff=0.4)
for m in matches:
    print(f'    - {m}')
" 2>/dev/null
}
