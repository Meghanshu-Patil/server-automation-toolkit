#!/usr/bin/env bash



# Without root we can't write to /var/log, so fall back to a temp dir
# rather than letting every single log line fail.
mkdir -p "$LOG_DIR" 2>/dev/null || LOG_DIR="${TMPDIR:-/tmp}"

log() {
    local message="$1"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local line="[$timestamp] [$SCRIPT_NAME] $message"

    echo "$line"                                  
    echo "$line" >> "$LOG_DIR/${SCRIPT_NAME}.log" 
}