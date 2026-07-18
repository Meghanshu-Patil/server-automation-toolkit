#!/usr/bin/env bash
# ============================================================
# config.sh — every setting the toolkit has, in one place.
# The scripts never hardcode a path or a number; they read
# them from here. So this is the only file you edit.
# ============================================================

# Where all the scripts write their logs. One file per script,
# named after it: backup.log, disk_alert.log, and so on.
LOG_DIR="/var/log/toolkit"

# --- Backups (scripts/backup.sh) ---
BACKUP_SOURCE="/home"               # the folder that gets backed up
BACKUP_DEST="/var/backups/toolkit"  # where the .tar.gz files pile up
BACKUP_RETENTION_DAYS=7             # anything older than this gets deleted

# --- Log cleanup (scripts/log_cleanup.sh) ---
# Searches this folder recursively and removes stale *.log files.
# Heads up: LOG_DIR lives inside /var/log, so the toolkit's own
# logs get cleaned up too once they pass the age limit.
CLEANUP_TARGET_DIR="/var/log"
CLEANUP_OLDER_THAN_DAYS=14

# --- Service monitoring (scripts/service_monitor.sh) ---
# Space-separated systemd units. If one is down, it gets restarted.
SERVICES_TO_MONITOR="ssh cron"

# --- Disk alerts (scripts/disk_alert.sh) ---
DISK_THRESHOLD_PERCENT=80           # log an ALERT once usage hits this
DISK_MOUNT="/"                      # the mount point being watched
