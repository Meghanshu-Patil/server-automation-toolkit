#!/usr/bin/env bash
# ============================================================
# lib/logging.sh  —  A tiny logging helper shared by all scripts.
# Usage inside a script:   log "something happened"
# It prints to the screen AND appends to that script's log file.
# ============================================================

# Make sure the log directory exists (created once, harmless if it already does)
mkdir -p "$LOG_DIR" 2>/dev/null

log() {
    local message="$1"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    # $SCRIPT_NAME is set by each script that sources this file
    local line="[$timestamp] [$SCRIPT_NAME] $message"

    echo "$line"                                  # show on screen
    echo "$line" >> "$LOG_DIR/${SCRIPT_NAME}.log" # save to file
}