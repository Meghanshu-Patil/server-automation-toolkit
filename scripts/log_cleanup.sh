#!/usr/bin/env bash


set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/config.sh"
SCRIPT_NAME="log_cleanup"
source "$SCRIPT_DIR/lib/logging.sh"

log "Looking for *.log files older than $CLEANUP_OLDER_THAN_DAYS days in $CLEANUP_TARGET_DIR"


deleted="$(find "$CLEANUP_TARGET_DIR" -type f -name '*.log' -mtime +"$CLEANUP_OLDER_THAN_DAYS" -print -delete 2>/dev/null | wc -l)"

log "Deleted $deleted old log file(s)"
log "Log cleanup finished"