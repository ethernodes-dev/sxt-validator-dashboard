#!/usr/bin/env bash
# SXT logo: full ASCII (wide terminals) + compact (narrow terminals).
#
# The art is plain ASCII without color escapes — guaranteed to render
# correctly on any terminal regardless of color support.

print_logo() {
    local cols
    cols="$(tput cols 2>/dev/null || echo 80)"

    if [ "$cols" -ge 90 ]; then
        print_logo_full
    else
        print_logo_compact
    fi
}

print_logo_full() {
    local logo_file="$INSTALL_DIR/assets/sxt_logo.txt"
    if [ -f "$logo_file" ]; then
        cat "$logo_file"
    else
        print_logo_compact
    fi
}

print_logo_compact() {
    cat <<'COMPACT'

   ============================
     SPACE AND TIME
     Validator Dashboard
   ============================

COMPACT
}

print_banner() {
    print_logo
    printf '\n'
    printf '   Validator Dashboard — installer\n'
    printf '   Space and Time mainnet\n'
    printf '\n'
}
