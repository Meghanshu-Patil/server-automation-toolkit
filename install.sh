#!/usr/bin/env bash


set -euo pipefail

INSTALL_DIR="/opt/toolkit"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ">> Installing Server Automation Toolkit to $INSTALL_DIR"

mkdir -p "$INSTALL_DIR"
cp -r "$SOURCE_DIR/scripts" "$SOURCE_DIR/lib" "$SOURCE_DIR/config.sh" "$INSTALL_DIR/"

chmod +x "$INSTALL_DIR/scripts/"*.sh
echo ">> Scripts copied and made executable"

mkdir -p /var/log/toolkit
echo ">> Log directory ready at /var/log/toolkit"

cp "$SOURCE_DIR/cron/toolkit-cron" /etc/cron.d/toolkit
chmod 644 /etc/cron.d/toolkit
echo ">> Cron schedule installed at /etc/cron.d/toolkit"

echo ">> Done! The toolkit is deployed and scheduled."
echo ">> Watch it work with:  tail -f /var/log/toolkit/*.log"