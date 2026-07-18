# Linux Server Automation Toolkit

[![CI](https://github.com/Meghanshu-Patil/server-automation-toolkit/actions/workflows/ci.yml/badge.svg)](https://github.com/Meghanshu-Patil/server-automation-toolkit/actions/workflows/ci.yml)

A collection of Bash scripts that automate everyday server maintenance:
backups, log cleanup, service monitoring, and disk usage alerts — all
scheduled with cron and version-controlled with Git.

## What each script does

- scripts/backup.sh — compresses a folder into a timestamped .tar.gz, stores it, and deletes backups older than 7 days
- scripts/log_cleanup.sh — deletes .log files older than 14 days to free up space
- scripts/service_monitor.sh — checks that key services are running, and restarts any that are down
- scripts/disk_alert.sh — raises an alert when disk usage crosses 80%

All settings live in config.sh. Change values there — you never edit the scripts.

## Deploy to a server

1. Push this repo to GitHub.
2. On your Linux server: git clone the repo and cd into it.
3. Run: sudo ./install.sh
4. Watch it run: tail -f /var/log/toolkit/*.log

## The cron schedule

- Backup: every night at 2:30 AM
- Log cleanup: every Sunday at 3:00 AM
- Service monitor: every 5 minutes
- Disk alert: every 15 minutes