#!/usr/bin/env bash
# SXT brand palette — ANSI 24-bit color (true color).
# Falls back gracefully when the terminal does not advertise color support.

# Detect color support
if [ -t 1 ] && [ "${NO_COLOR:-}" = "" ]; then
    if command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
        SXT_HAS_COLOR=1
    else
        SXT_HAS_COLOR=0
    fi
else
    SXT_HAS_COLOR=0
fi

if [ "$SXT_HAS_COLOR" = "1" ]; then
    # SXT brand colors (24-bit ANSI)
    SXT_MAGENTA='\033[38;2;204;10;172m'   # #CC0AAC
    SXT_PURPLE='\033[38;2;80;0;191m'      # #5000BF
    SXT_LIGHT='\033[38;2;230;230;230m'    # #E6E6E6
    SXT_DIM='\033[38;2;160;144;181m'      # #A090B5
    SXT_DIMMER='\033[38;2;111;77;128m'    # #6F4D80

    # Status colors
    SXT_GREEN='\033[38;2;0;200;83m'
    SXT_YELLOW='\033[38;2;255;193;7m'
    SXT_RED='\033[38;2;239;83;80m'

    # Style
    SXT_BOLD='\033[1m'
    SXT_DIM_STYLE='\033[2m'
    SXT_RESET='\033[0m'
else
    SXT_MAGENTA=''
    SXT_PURPLE=''
    SXT_LIGHT=''
    SXT_DIM=''
    SXT_DIMMER=''
    SXT_GREEN=''
    SXT_YELLOW=''
    SXT_RED=''
    SXT_BOLD=''
    SXT_DIM_STYLE=''
    SXT_RESET=''
fi

# Print helpers — always use printf, never echo -e (busybox/dash safety)
sxt_color()   { printf '%b%s%b' "$1" "$2" "$SXT_RESET"; }
sxt_magenta() { sxt_color "$SXT_MAGENTA" "$1"; }
sxt_purple()  { sxt_color "$SXT_PURPLE"  "$1"; }
sxt_dim()     { sxt_color "$SXT_DIM"     "$1"; }
sxt_bold()    { sxt_color "$SXT_BOLD"    "$1"; }

# Export so subshells (e.g. python3 in lib_logo.sh) inherit the colors.
export SXT_MAGENTA SXT_PURPLE SXT_LIGHT SXT_DIM SXT_DIMMER
export SXT_GREEN SXT_YELLOW SXT_RED
export SXT_BOLD SXT_DIM_STYLE SXT_RESET
