#!/usr/bin/env bash
# Pre-flight checks: docker, compose v2, openssl, python3, curl, perms.

step_preflight() {
    step "Pre-flight checks"

    local fail=0

    # 1. docker
    if ! command -v docker >/dev/null 2>&1; then
        error "Docker is not installed."
        info  "    See https://docs.docker.com/engine/install/"
        fail=1
    else
        local v
        v="$(docker --version 2>/dev/null | awk '{print $3}' | tr -d ',')"
        ok "Docker found ($v)"
    fi

    # 2. docker compose v2 (the plugin, not docker-compose)
    if ! docker compose version >/dev/null 2>&1; then
        error "Docker Compose v2 is not available."
        info  "    Install the docker-compose-plugin package."
        fail=1
    else
        local cv
        cv="$(docker compose version --short 2>/dev/null)"
        ok "Docker Compose v2 found ($cv)"
    fi

    # 3. openssl (for password generation)
    if ! command -v openssl >/dev/null 2>&1; then
        warn "openssl not found — falling back to /dev/urandom."
    else
        ok "openssl found"
    fi

    # 4. python3 (for template rendering and JSON parsing)
    if ! command -v python3 >/dev/null 2>&1; then
        error "python3 is required but not installed."
        info  "    On Debian/Ubuntu:  sudo apt install python3"
        fail=1
    else
        ok "python3 found"
    fi

    # 5. curl
    if ! command -v curl >/dev/null 2>&1; then
        error "curl is required but not installed."
        fail=1
    else
        ok "curl found"
    fi

    # 6. Docker access (user in docker group, or running as root)
    if ! docker info >/dev/null 2>&1; then
        error "Cannot talk to Docker daemon."
        info  "    Run as root, or add your user to the docker group:"
        info  "      sudo usermod -aG docker \$USER  &&  newgrp docker"
        fail=1
    else
        ok "Docker daemon reachable"
    fi

    if [ "$fail" -eq 1 ]; then
        error "Pre-flight checks failed.  Fix the issues above and re-run."
        return 1
    fi
    return 0
}
