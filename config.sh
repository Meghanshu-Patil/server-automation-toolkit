#!/usr/bin/env bash



TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


LOG_DIR="/var/log/toolkit"         


BACKUP_SOURCE="/home"              
BACKUP_DEST="/var/backups/toolkit"  
BACKUP_RETENTION_DAYS=7             


CLEANUP_TARGET_DIR="/var/log"       
CLEANUP_OLDER_THAN_DAYS=14          


SERVICES_TO_MONITOR="ssh cron"


DISK_THRESHOLD_PERCENT=80           
DISK_MOUNT="/"                      