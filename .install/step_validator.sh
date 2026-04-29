#!/usr/bin/env bash
# Ask the operator for the validator display name and validate against
# the SXT staking API.

step_validator_name() {
    step "Validator name"

    info "Fetching the active validator list from $STAKING_API_URL..."
    fetch_staking_validators || true

    if [ -n "$STAKING_VALIDATOR_NAMES" ]; then
        local count
        count="$(printf '%s' "$STAKING_VALIDATOR_NAMES" | grep -c '.' || true)"
        ok "Got $count validators from the staking API."
    fi

    local name
    while :; do
        name="$(ask "Your validator's display name (exact match)" "${SXT_LOCAL_VALIDATOR:-}")"
        if [ -z "$name" ]; then
            error "Validator name cannot be empty."
            continue
        fi

        if [ -z "$STAKING_VALIDATOR_NAMES" ]; then
            warn "Skipped name validation (API unreachable)."
            warn "If the name is wrong, the dashboard will not pair with your node."
            if ask_yn "Use \"$name\" anyway?" "n"; then
                break
            fi
            continue
        fi

        if validator_name_exists "$name"; then
            ok "Found \"$name\" in the staking API."
            break
        fi

        error "\"$name\" is NOT in the active validator list."
        info "  Closest matches:"
        suggest_validator_names "$name"
        if ask_yn "Use \"$name\" anyway?  (only for unusual setups)" "n"; then
            warn "Continuing with unverified name — you have been warned."
            break
        fi
        # otherwise loop and ask again
    done

    SXT_LOCAL_VALIDATOR="$name"
    return 0
}
