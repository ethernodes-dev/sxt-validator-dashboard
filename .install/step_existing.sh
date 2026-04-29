#!/usr/bin/env bash
# Detect a prior installation: existing .env, existing project volumes.

step_detect_existing() {
    step "Detect existing installation"

    local has_env=0 has_volumes=0 has_containers=0
    local proj
    proj="${COMPOSE_PROJECT_NAME:-sxt-validator-dashboard}"

    if [ -f .env ]; then
        has_env=1
    fi
    if docker volume ls --format '{{.Name}}' 2>/dev/null | grep -qE "^${proj}_" ; then
        has_volumes=1
    fi
    if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -qE "^${proj}-" ; then
        has_containers=1
    fi

    if [ "$has_env$has_volumes$has_containers" = "000" ]; then
        ok "Fresh install — no prior state detected."
        EXISTING_INSTALL=0
        return 0
    fi

    warn "Prior installation detected:"
    [ "$has_env" = "1" ]        && info "    - .env file present"
    [ "$has_volumes" = "1" ]    && info "    - Docker volumes for project '$proj'"
    [ "$has_containers" = "1" ] && info "    - Containers for project '$proj'"

    local choice
    choice="$(ask_choice "What do you want to do?" "Keep existing data and continue" \
        "Keep existing data and continue" \
        "Wipe everything and start fresh (DESTRUCTIVE)" \
        "Cancel installation")"

    case "$choice" in
        "Keep existing data and continue")
            EXISTING_INSTALL=1
            ok "Continuing with existing data."
            ;;
        "Wipe everything and start fresh (DESTRUCTIVE)")
            if ! ask_yn "Really wipe all data?  This cannot be undone." "n"; then
                error "Aborted."
                return 1
            fi
            info "Wiping..."
            docker compose -p "$proj" down -v 2>/dev/null || true
            rm -f .env
            EXISTING_INSTALL=0
            ok "Wiped clean."
            ;;
        "Cancel installation")
            error "Cancelled by user."
            return 1
            ;;
    esac
    return 0
}
