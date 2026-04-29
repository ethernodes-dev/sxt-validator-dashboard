#!/usr/bin/env bash
# Returns 0 if the host port is free, 1 if in use.
# Uses ss if available, falls back to netstat, then to /proc/net/tcp.

port_in_use() {
    local port="$1"
    if command -v ss >/dev/null 2>&1; then
        ss -tln 2>/dev/null | awk '{print $4}' | grep -qE "[:.]${port}\$"
    elif command -v netstat >/dev/null 2>&1; then
        netstat -tln 2>/dev/null | awk '{print $4}' | grep -qE "[:.]${port}\$"
    else
        # Convert decimal port to 4-char hex (uppercase)
        local hex
        hex="$(printf '%04X' "$port")"
        grep -E "^[ ]*[0-9]+:.*:${hex} " /proc/net/tcp 2>/dev/null | grep -q . || \
            grep -E "^[ ]*[0-9]+:.*:${hex} " /proc/net/tcp6 2>/dev/null | grep -q .
    fi
}

# Find a free port starting from $1, incrementing.  Skips occupied ports.
# Limits to 100 attempts to avoid infinite loops.
find_free_port() {
    local start="$1"
    local max="${2:-65535}"
    local port="$start"
    local tries=0
    while [ "$tries" -lt 100 ]; do
        if [ "$port" -gt "$max" ]; then
            return 1
        fi
        if ! port_in_use "$port"; then
            printf '%d\n' "$port"
            return 0
        fi
        port=$((port + 1))
        tries=$((tries + 1))
    done
    return 1
}
