#!/usr/bin/env bash


set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/config.sh"
SCRIPT_NAME="disk_alert"
source "$SCRIPT_DIR/lib/logging.sh"


usage="$(df --output=pcent "$DISK_MOUNT" | tail -1 | tr -d ' %')"

log "Disk usage on $DISK_MOUNT is ${usage}% (threshold: ${DISK_THRESHOLD_PERCENT}%)"

if [ "$usage" -ge "$DISK_THRESHOLD_PERCENT" ]; then
    log "ALERT: disk usage ${usage}% has crossed the ${DISK_THRESHOLD_PERCENT}% threshold!"

   
else
    log "Disk usage is within safe limits"
fi

log "Disk check finished"