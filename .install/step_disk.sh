#!/usr/bin/env bash
step_disk() {
    step "SXT data directory"
    info "The dashboard tracks disk usage of the partition that contains"
    info "your SXT node's data directory."
    SXT_DATA_MOUNTPOINT="$(ask "Mountpoint of your SXT node data directory" "/sxt-data")"
    if [ -d "$SXT_DATA_MOUNTPOINT" ]; then
        ok "Directory exists: $SXT_DATA_MOUNTPOINT"
    else
        warn "Directory \"$SXT_DATA_MOUNTPOINT\" does not exist on this host."
        warn "Continuing — you can edit .env later if needed."
    fi
    return 0
}
