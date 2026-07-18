#!/usr/bin/env bash

set -uo pipefail   

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/config.sh"
SCRIPT_NAME="service_monitor"
source "$SCRIPT_DIR/lib/logging.sh"

log "Checking services: $SERVICES_TO_MONITOR"

for service in $SERVICES_TO_MONITOR; do
    if systemctl is-active --quiet "$service"; then
        log "OK: $service is running"
    else
        log "WARNING: $service is DOWN — attempting restart"
        if systemctl restart "$service" 2>/dev/null; then
            log "RECOVERED: $service was restarted successfully"
        else
            log "ERROR: failed to restart $service"
        fi
    fi
done

log "Service check finished"