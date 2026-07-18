#!/usr/bin/env bash


set -euo pipefail  

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/config.sh"
SCRIPT_NAME="backup"
source "$SCRIPT_DIR/lib/logging.sh"

log "Starting backup of $BACKUP_SOURCE"


mkdir -p "$BACKUP_DEST"


timestamp="$(date '+%Y-%m-%d_%H%M')"
archive="$BACKUP_DEST/backup-$timestamp.tar.gz"


if tar -czf "$archive" "$BACKUP_SOURCE" 2>/dev/null; then
    size="$(du -h "$archive" | cut -f1)"
    log "Backup created: $archive ($size)"
else
    log "ERROR: backup failed"
    exit 1
fi


deleted="$(find "$BACKUP_DEST" -name 'backup-*.tar.gz' -mtime +"$BACKUP_RETENTION_DAYS" -print -delete | wc -l)"
log "Removed $deleted old backup(s) older than $BACKUP_RETENTION_DAYS days"

log "Backup finished successfully"