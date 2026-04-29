#!/usr/bin/env bash
#==============================================================================
# SXT Validator Dashboard — installer
#
# Interactive installer for new operators.  Prompts for everything required,
# generates strong passwords, validates the validator name against the SXT
# staking API, lays down a working .env, brings up the stack, and optionally
# launches the historical backfill in background.
#
# Usage:
#   ./install.sh                  # interactive (default)
#   ./install.sh --non-interactive  # CI mode — uses defaults, fails on missing input
#
# Re-running on an existing installation is safe: detects prior state and
# offers continue / wipe / cancel.
#==============================================================================
set -euo pipefail

cd "$(dirname "$0")"

# ----------------------------------------------------------------------------
# Argument parsing
# ----------------------------------------------------------------------------
NON_INTERACTIVE=0
for arg in "$@"; do
    case "$arg" in
        --non-interactive|-y)  NON_INTERACTIVE=1 ;;
        --help|-h)
            sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
            exit 0
            ;;
        *)
            printf 'Unknown argument: %s\n' "$arg" >&2
            exit 2
            ;;
    esac
done
export NON_INTERACTIVE

# ----------------------------------------------------------------------------
# Library + step sourcing
# ----------------------------------------------------------------------------
INSTALL_DIR="$(pwd)/.install"
if [ ! -d "$INSTALL_DIR" ]; then
    printf 'ERROR: .install/ directory not found.  Are you running from the repo root?\n' >&2
    exit 2
fi

# Init log
INSTALL_LOG="$(pwd)/install.log"
: > "$INSTALL_LOG"
export INSTALL_LOG

# shellcheck disable=SC1091
. "$INSTALL_DIR/lib_colors.sh"
# shellcheck disable=SC1091
. "$INSTALL_DIR/lib_logo.sh"
# shellcheck disable=SC1091
. "$INSTALL_DIR/lib_log.sh"
# shellcheck disable=SC1091
. "$INSTALL_DIR/lib_validate.sh"
# shellcheck disable=SC1091
. "$INSTALL_DIR/lib_ports.sh"
# shellcheck disable=SC1091
. "$INSTALL_DIR/lib_passwords.sh"

for step in preflight existing validator endpoints disk ports passwords bind summary render boot backfill final; do
    # shellcheck disable=SC1090
    . "$INSTALL_DIR/step_${step}.sh"
done

# ----------------------------------------------------------------------------
# Cleanup trap: if the script dies mid-way, leave a hint in install.log.
# ----------------------------------------------------------------------------
on_exit() {
    local rc=$?
    if [ "$rc" -ne 0 ]; then
        printf '\n%b✗ Installer exited with status %d%b\n' "$SXT_RED" "$rc" "$SXT_RESET" >&2
        printf '  Full log: %s\n' "$INSTALL_LOG" >&2
    fi
}
trap on_exit EXIT

# ----------------------------------------------------------------------------
# Banner
# ----------------------------------------------------------------------------
clear 2>/dev/null || true
print_banner

# ----------------------------------------------------------------------------
# Run all steps in order.  Any non-zero return aborts the installer.
# ----------------------------------------------------------------------------
step_preflight        || exit 1
step_detect_existing  || exit 1
step_validator_name   || exit 1
step_endpoints        || exit 1
step_disk             || exit 1
step_ports            || exit 1
step_passwords        || exit 1
step_bind             || exit 1
step_summary          || exit 1
step_render           || exit 1
step_boot             || exit 1
step_backfill         || exit 1
step_final            || exit 1

exit 0
