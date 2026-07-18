#!/usr/bin/env bash
# ============================================================
# config.sh  —  Central settings for the whole toolkit.
# Every script reads its values from here, so you only edit
# paths and thresholds in ONE place.
# ============================================================

# --- Where the toolkit lives (auto-detected, no need to change) ---
TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Logging ---
LOG_DIR="/var/log/toolkit"          # all scripts write their logs here

# --- Backup settings ---
BACKUP_SOURCE="/home"               # folder you want to back up
BACKUP_DEST="/var/backups/toolkit"  # where backups are stored
BACKUP_RETENTION_DAYS=7             # delete backups older than this

# --- Log cleanup settings ---
CLEANUP_TARGET_DIR="/var/log"       # folder to clean old logs from
CLEANUP_OLDER_THAN_DAYS=14          # delete *.log files older than this

# --- Service monitoring ---
# Space-separated list of systemd services to keep an eye on.
SERVICES_TO_MONITOR="ssh cron"

# --- Disk usage alerting ---
DISK_THRESHOLD_PERCENT=80           # alert when disk usage crosses this %
DISK_MOUNT="/"                      # which mount point to check