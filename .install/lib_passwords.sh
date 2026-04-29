#!/usr/bin/env bash
# Generate strong passwords with openssl. 24 bytes base64 = 32 chars,
# enough entropy for any production use, no shell-special chars
# guaranteed (we strip $, /, \, `, ', ", and # to be safe with the
# whole render pipeline).

gen_password() {
    local raw
    raw="$(openssl rand -base64 24 2>/dev/null | tr -d '\n')"
    if [ -z "$raw" ]; then
        # Fallback: /dev/urandom + base64 (busybox)
        raw="$(head -c 24 /dev/urandom | base64 | tr -d '\n')"
    fi
    # Strip chars that are problematic in shell, sql, yaml, json contexts.
    printf '%s' "$raw" | tr -d '$/\`'"'"'"#'
}

# Show a masked version of a password for confirmation messages.
# "abc123def456" -> "abc***456"
mask_password() {
    local p="$1"
    local len="${#p}"
    if [ "$len" -le 8 ]; then
        printf '%s\n' "***"
    else
        printf '%s***%s\n' "${p:0:3}" "${p: -3}"
    fi
}
