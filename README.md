# Linux Server Automation Toolkit

A collection of Bash scripts that automate everyday Linux server maintenance —
**backups, log cleanup, service monitoring, and disk-usage alerts** — scheduled
with **cron**, checked automatically by a **GitHub Actions** CI pipeline, and
**deployed on an AWS EC2 instance**.


![CI](https://github.com/Meghanshu-Patil/server-automation-toolkit/actions/workflows/ci.yml/badge.svg)

---

## Overview

Keeping a Linux server healthy involves the same chores over and over: backing
up important folders, clearing out old logs, making sure critical services stay
up, and watching disk space. This toolkit turns those chores into small,
independent Bash scripts and lets **cron** run them automatically on a schedule,
so the server maintains itself.

All four scripts share a single settings file (`config.sh`) and a common logging
helper, so behaviour is easy to configure in one place and every action is
recorded to a log file.

---

## Features

| Script | What it does |
|--------|--------------|
| `scripts/backup.sh` | Compresses a chosen folder into a timestamped `.tar.gz` archive, stores it, and automatically deletes backups older than a set number of days (default 7). |
| `scripts/log_cleanup.sh` | Deletes `.log` files older than a set number of days (default 14) to free up disk space. |
| `scripts/service_monitor.sh` | Checks that important services (e.g. `ssh`, `cron`) are running, and automatically restarts any that are down — with the recovery logged. |
| `scripts/disk_alert.sh` | Checks disk usage on a mount point and raises an alert (logged, with optional email) when usage crosses a threshold (default 80%). |

Supporting pieces:

- **`config.sh`** — one central place for all paths, thresholds, and settings. You never edit the scripts themselves.
- **`lib/logging.sh`** — a shared logging function; every script writes timestamped entries to its own log file under `/var/log/toolkit/`.
- **`install.sh`** — deploys the toolkit and installs the cron schedule in one command.
- **`.github/workflows/ci.yml`** — a GitHub Actions pipeline that syntax-checks and lints every script on each push.

---

## Project structure

```
server-automation-toolkit/
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions CI (runs on every push)
├── config.sh                 # all settings live here
├── install.sh                # deploys the toolkit + sets up cron
├── .gitignore
├── README.md
├── lib/
│   └── logging.sh            # shared logging helper
├── scripts/
│   ├── backup.sh
│   ├── log_cleanup.sh
│   ├── service_monitor.sh
│   └── disk_alert.sh
└── cron/
    └── toolkit-cron          # the automation schedule
```

---

## Configuration

All settings live in `config.sh`. Edit the values there to suit your server:

| Setting | Meaning | Default |
|---------|---------|---------|
| `LOG_DIR` | Where all scripts write their logs | `/var/log/toolkit` |
| `BACKUP_SOURCE` | Folder to back up | `/home` |
| `BACKUP_DEST` | Where backups are stored | `/var/backups/toolkit` |
| `BACKUP_RETENTION_DAYS` | Delete backups older than this | `7` |
| `CLEANUP_TARGET_DIR` | Folder to clean old logs from | `/var/log` |
| `CLEANUP_OLDER_THAN_DAYS` | Delete `.log` files older than this | `14` |
| `SERVICES_TO_MONITOR` | Services to keep running | `ssh cron` |
| `DISK_THRESHOLD_PERCENT` | Alert when usage crosses this % | `80` |
| `DISK_MOUNT` | Mount point to check | `/` |

---

## The cron schedule

Defined in `cron/toolkit-cron` and installed to `/etc/cron.d/toolkit`:

| Task | Frequency |
|------|-----------|
| Backup | Every night at 2:30 AM |
| Log cleanup | Every Sunday at 3:00 AM |
| Service monitor | Every 5 minutes |
| Disk alert | Every 15 minutes |

---

## Continuous Integration (GitHub Actions)

Every push to `main` triggers `.github/workflows/ci.yml`, which:

1. Checks out the code on a fresh Ubuntu runner.
2. Runs a **Bash syntax check** (`bash -n`) on every script.
3. Installs and runs **ShellCheck** to lint all scripts for common bugs.

A green check next to a commit means every script is valid. (Three ShellCheck
warnings — SC1091, SC2034, SC2154 — are intentionally excluded because they are
expected side-effects of the multi-file `source` design, not real issues.)

---

## Run it locally (safe testing)

Before deploying, you can run any script by hand on a local machine or WSL:

```bash
chmod +x scripts/*.sh
./scripts/disk_alert.sh
```

Then check its log:

```bash
cat /var/log/toolkit/disk_alert.log
```

> Tip: for safe local testing, point `BACKUP_SOURCE` and `CLEANUP_TARGET_DIR`
> in `config.sh` at a harmless test folder (e.g. `/tmp/test`) so you don't touch
> real system files.

---

## Deploy on AWS EC2

**1. Launch an instance**
EC2 → **Launch instance** → **Ubuntu** (Free tier eligible) →
**t3.micro / t2.micro** (Free tier eligible) → create/reuse a key pair →
allow **SSH traffic (My IP)** → **Launch instance**. Wait for **Running** with a
green status check.

**2. Connect**
Select the instance → **Connect** → **EC2 Instance Connect** → **Connect**.
A terminal opens in the browser.

**3. Clone and install** (replace `YOUR_USERNAME`):

```bash
sudo apt update && sudo apt install -y git dos2unix
git clone https://github.com/YOUR_USERNAME/server-automation-toolkit.git
cd server-automation-toolkit
dos2unix config.sh install.sh lib/*.sh scripts/*.sh cron/toolkit-cron
sudo bash install.sh
```

`install.sh` copies everything to `/opt/toolkit`, creates the log directory, and
installs the cron schedule. **You only run it once per server** — after that,
cron runs the scripts automatically in the background.

> `dos2unix` is included as a safeguard: files edited on Windows can carry hidden
> line-ending characters that break Bash on Linux. This converts them once.

---

## Verify everything works

```bash
# 1. Confirm files and schedule are installed
ls -l /opt/toolkit/scripts/
cat /etc/cron.d/toolkit

# 2. Run each script manually
sudo /opt/toolkit/scripts/disk_alert.sh
sudo /opt/toolkit/scripts/service_monitor.sh
sudo /opt/toolkit/scripts/log_cleanup.sh
sudo /opt/toolkit/scripts/backup.sh

# 3. Check the logs and the backup file
ls -l /var/log/toolkit/
ls -lh /var/backups/toolkit/

# 4. Confirm cron runs the scripts automatically
grep CRON /var/log/syslog | tail -n 10
```

In step 4, lines reading `(root) CMD (/opt/toolkit/scripts/...)` are cron
executing the scripts on schedule — that is the proof of automated deployment.
Entries in the logs that land on exact schedule boundaries (e.g. every 5 minutes)
confirm the same.

> **Note on `No MTA installed, discarding output`:** this common cron message is
> harmless. It only means the server has no mail program to email script output
> to, so cron discards that copy. The scripts still run and still write their
> logs. To silence it, add `MAILTO=""` as the first line of `/etc/cron.d/toolkit`.

---

## Redeploying on a new instance

Because the project is version-controlled on GitHub, deploying to any new server
is just: launch Ubuntu → connect → clone → `dos2unix` → `sudo bash install.sh`.
Run `install.sh` **once** on each new instance.

To push code changes to an existing server: `git pull` the update, then run
`sudo bash install.sh` again to copy the new files into place.

---

## Tech stack

**Linux · Bash · cron · Git · GitHub Actions (CI) · AWS EC2 · ShellCheck**

---

## License

Free to use and adapt for learning and personal projects.