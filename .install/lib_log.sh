#!/usr/bin/env bash
# Logging helpers — info / warn / error / step / ask.
# All output also goes to install.log if INSTALL_LOG is set.

INSTALL_LOG="${INSTALL_LOG:-./install.log}"

_log_to_file() {
    if [ -n "$INSTALL_LOG" ]; then
        printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" >> "$INSTALL_LOG" 2>/dev/null || true
    fi
}

step() {
    printf '\n%b▸ %s%b\n' "$SXT_MAGENTA$SXT_BOLD" "$1" "$SXT_RESET"
    _log_to_file "STEP: $1"
}

info() {
    printf '  %s\n' "$1"
    _log_to_file "INFO: $1"
}

ok() {
    printf '  %b✓%b %s\n' "$SXT_GREEN" "$SXT_RESET" "$1"
    _log_to_file "OK: $1"
}

warn() {
    printf '  %b!%b %s\n' "$SXT_YELLOW" "$SXT_RESET" "$1"
    _log_to_file "WARN: $1"
}

error() {
    printf '  %b✗%b %s\n' "$SXT_RED" "$SXT_RESET" "$1" >&2
    _log_to_file "ERROR: $1"
}

# ask "Question text" "default-value"  -> prints answer to stdout
# In non-interactive mode, prints default.
ask() {
    local prompt="$1"
    local default="${2:-}"
    local answer

    if [ "${NON_INTERACTIVE:-0}" = "1" ]; then
        printf '%s\n' "$default"
        _log_to_file "ASK [$prompt] -> $default (non-interactive)"
        return
    fi

    if [ -n "$default" ]; then
        printf '  %b?%b %s [%s]: ' "$SXT_MAGENTA" "$SXT_RESET" "$prompt" "$default" >/dev/tty
    else
        printf '  %b?%b %s: ' "$SXT_MAGENTA" "$SXT_RESET" "$prompt" >/dev/tty
    fi
    read -r answer </dev/tty
    if [ -z "$answer" ]; then
        answer="$default"
    fi
    printf '%s\n' "$answer"
    _log_to_file "ASK [$prompt] -> $answer"
}

# ask_yn "Question?" "y"  -> returns 0 (yes) or 1 (no)
ask_yn() {
    local prompt="$1"
    local default="${2:-y}"
    local answer

    if [ "${NON_INTERACTIVE:-0}" = "1" ]; then
        case "$default" in y|Y) return 0 ;; *) return 1 ;; esac
    fi

    while :; do
        printf '  %b?%b %s [%s/n]: ' "$SXT_MAGENTA" "$SXT_RESET" "$prompt" \
               "$([ "$default" = "y" ] && echo "Y" || echo "y")" >/dev/tty
        read -r answer </dev/tty
        answer="${answer:-$default}"
        case "$answer" in
            y|Y|yes|Yes|YES) _log_to_file "ASK_YN [$prompt] -> yes"; return 0 ;;
            n|N|no|No|NO)    _log_to_file "ASK_YN [$prompt] -> no";  return 1 ;;
            *) printf '    please answer y or n\n' >/dev/tty ;;
        esac
    done
}

# ask_choice "Pick:" "opt1" "opt2" "opt3"  -> prints chosen value
ask_choice() {
    local prompt="$1"; shift
    local default="$1"; shift
    local opts=("$@")
    local i answer

    if [ "${NON_INTERACTIVE:-0}" = "1" ]; then
        printf '%s\n' "$default"
        return
    fi

    printf '  %b?%b %s\n' "$SXT_MAGENTA" "$SXT_RESET" "$prompt" >/dev/tty
    for i in "${!opts[@]}"; do
        local marker=" "
        [ "${opts[$i]}" = "$default" ] && marker="*"
        printf '      %s [%d] %s\n' "$marker" "$((i+1))" "${opts[$i]}" >/dev/tty
    done
    while :; do
        printf '  Choose [1-%d]: ' "${#opts[@]}" >/dev/tty
        read -r answer </dev/tty
        if [ -z "$answer" ]; then
            printf '%s\n' "$default"
            return
        fi
        if [[ "$answer" =~ ^[0-9]+$ ]] && [ "$answer" -ge 1 ] && [ "$answer" -le "${#opts[@]}" ]; then
            printf '%s\n' "${opts[$((answer-1))]}"
            return
        fi
        printf '    invalid choice\n' >/dev/tty
    done
}
