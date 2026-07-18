#!/usr/bin/env bash



mkdir -p "$LOG_DIR" 2>/dev/null

log() {
    local message="$1"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local line="[$timestamp] [$SCRIPT_NAME] $message"

    echo "$line"                                  
    echo "$line" >> "$LOG_DIR/${SCRIPT_NAME}.log" 
}