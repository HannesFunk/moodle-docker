# Running multiple Moodle versions with moodle-docker

Three parallel instances are configured via `git worktree` and separate Docker
project names/ports.

## Layout

```
moodle-fork/
├── bin/
│   ├── instance-compose          ← multi-instance wrapper (use this)
│   └── moodle-docker-compose     ← single-instance helper (called internally)
├── instances/
│   ├── main.env                  ← Moodle 5.2dev  → http://localhost:8000
│   ├── v501.env                  ← Moodle 5.1     → http://localhost:8051
│   └── v500.env                  ← Moodle 5.0     → http://localhost:8050
├── moodle/                       ← git worktree: main/5.2dev (active branch)
├── moodle-501/                   ← git worktree: origin/MOODLE_501_STABLE
└── moodle-500/                   ← git worktree: origin/MOODLE_500_STABLE
```

Each instance gets its own isolated set of Docker containers because of the
distinct `COMPOSE_PROJECT_NAME` value.

## One-time setup per instance

### 1. Start the containers

```bash
cd /home/hannes/coding/moodle-fork

bin/instance-compose main  up -d
bin/instance-compose v501  up -d
bin/instance-compose v500  up -d
```

### 2. Wait for the DB, then install Moodle

```bash
# main (5.2)
bin/instance-compose main exec webserver php admin/cli/install_database.php \
  --agree-license --adminpass="test" --adminemail="admin@example.com" \
  --fullname="Moodle 5.2" --shortname="moodle52"

# v501 (5.1)
bin/instance-compose v501 exec webserver php admin/cli/install_database.php \
  --agree-license --adminpass="test" --adminemail="admin@example.com" \
  --fullname="Moodle 5.1" --shortname="moodle501"

# v500 (5.0)
bin/instance-compose v500 exec webserver php admin/cli/install_database.php \
  --agree-license --adminpass="test" --adminemail="admin@example.com" \
  --fullname="Moodle 5.0" --shortname="moodle500"
```

## Day-to-day commands

```bash
# Stop all without destroying data
bin/instance-compose main  stop
bin/instance-compose v501  stop
bin/instance-compose v500  stop

# Restart
bin/instance-compose main  start
bin/instance-compose v501  start

# Destroy completely (removes containers + DB volume)
bin/instance-compose main  down
bin/instance-compose v501  down

# Run a CLI command on a specific instance
bin/instance-compose v501 exec webserver php admin/cli/cron.php

# Open a shell
bin/instance-compose main exec webserver bash
```

## Ports

| Instance | Version    | Moodle URL              | phpMyAdmin URL          | COMPOSE_PROJECT_NAME |
|----------|------------|-------------------------|-------------------------|----------------------|
| `main`   | 5.2dev     | http://localhost:8000   | http://localhost:8081   | moodle52             |
| `v501`   | 5.1 STABLE | http://localhost:8051   | http://localhost:8061   | moodle501            |
| `v500`   | 5.0 STABLE | http://localhost:8050   | http://localhost:8060   | moodle500            |

## Updating a stable worktree

```bash
cd /home/hannes/coding/moodle-fork/moodle-501
git fetch origin MOODLE_501_STABLE
git merge origin/MOODLE_501_STABLE
```

## Notes

- `moodle-500` uses the **flat** Moodle layout (`version.php` at root).
  `moodle-501` and `moodle` use the **`public/`** layout introduced in 5.1.
  The `moodlehq/moodle-php-apache` Docker image auto-detects both layouts.
- Each `config.php` was copied from `config.docker-template.php`. If you need
  to customise one instance (e.g. different debug settings), edit its
  `moodle-NNN/config.php` directly — it is git-ignored.


