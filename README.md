# Homebase

Homebase is a Docker Compose-based self-hosted stack for running a small personal homelab. It is split into two service groups:

- `services/core` for dashboarding, monitoring, backups, logs, and container management
- `services/storage` for file storage and media/library services

The repo is structured so that hand-managed configuration lives alongside each stack, while generated app state stays in local volume directories that are ignored by Git.

## What This Runs

### Core services

- `Homepage`: dashboard
- `Portainer`: Docker management UI
- `Uptime Kuma`: service monitoring
- `Autokuma`: auto-registers monitors from Docker labels
- `Dozzle`: container log viewer
- `Duplicati`: backups
- `Nginx Proxy Manager`: reverse proxy UI

### Storage services

- `Nextcloud`: file storage and sync
- `Calibre Web`: ebook library
- `MariaDB`: Nextcloud database
- `Redis`: Nextcloud cache/session backend

Commented-out services in the compose files are not currently active.

## Project Layout

```text
homebase/
  .env.example
  start.sh
  stop.sh
  docs/
  services/
    core/
      docker-compose.yml
      config/
      volumes/
    storage/
      docker-compose.yml
      volumes/
```

Rules of thumb:

- `config/` contains configuration you are expected to manage directly
- `volumes/` contains persistent runtime data and is ignored by Git
- the root `.env` file is the source of truth for both compose stacks

## Prerequisites

- Docker
- Docker Compose v2 (`docker compose`)
- A local `.env` file copied from `.env.example`

Optional but recommended:

- A machine/user setup that matches the LinuxServer `PUID=1000` and `PGID=1000` defaults
- Review of any host bind mounts before first run, especially Duplicati paths

## Quick Start

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Update the required values in `.env`:

   ```env
   ROOT_URL=http://localhost
   UPTIME_KUMA_USERNAME=admin
   UPTIME_KUMA_PASSWORD=change-me
   DUPLICATI_SETTINGS_ENCRYPTION_KEY=put-a-long-random-secret-here
   DUPLICATI_PASSWORD=change-me
   NEXTCLOUD_DB_PASSWORD=change-me
   NEXTCLOUD_DB_ROOT_PASSWORD=change-me
   NEXTCLOUD_ADMIN_USER=admin
   NEXTCLOUD_ADMIN_PASSWORD=change-me
   ```

3. Review host-mounted paths in [`services/core/docker-compose.yml`](/Users/iyasin/Documents/code/projects/Homebase/services/core/docker-compose.yml) if you are not using the original machine layout.

   `Duplicati` currently mounts:

   - `~/homebase-backups` to `/backups`
   - `~/homebase` to `/source/homebase:ro`

4. Start the stack:

   ```bash
   ./start.sh
   ```

`start.sh` will:

- load `.env`
- create the external Docker network `homebase` if it does not already exist
- start the core stack
- start the storage stack

## Default Local URLs

If `ROOT_URL=http://localhost`, the exposed services are expected at:

- `http://localhost:3000` for Homepage
- `http://localhost:3001` for Uptime Kuma
- `https://localhost:9443` for Portainer
- `http://localhost:9999` for Dozzle
- `http://localhost:8200` for Duplicati
- `http://localhost:81` for Nginx Proxy Manager
- `http://localhost:8080` for Nextcloud
- `http://localhost:8083` for Calibre Web

## Operations

Start everything:

```bash
./start.sh
```

Stop everything:

```bash
./stop.sh
```

Check status:

```bash
docker compose --env-file .env -f services/core/docker-compose.yml ps
docker compose --env-file .env -f services/storage/docker-compose.yml ps
```

Restart one service:

```bash
docker compose --env-file .env -f services/core/docker-compose.yml restart homepage
```

Recreate one service:

```bash
docker compose --env-file .env -f services/core/docker-compose.yml up -d --force-recreate duplicati
docker compose --env-file .env -f services/storage/docker-compose.yml up -d calibre-web
```

View logs:

```bash
docker logs homepage
docker logs calibre-web
docker logs duplicati
docker logs nextcloud
```

## Configuration Notes

- Both compose files use the same external Docker network: `homebase`
- Missing required environment variables fail fast because the compose files use `${VAR:?message}` checks
- Browser-facing links and container-to-container targets are different
- Uptime Kuma and other internal checks should use Docker service names such as `homepage`, `nextcloud`, and `portainer`

## Known Caveat

Homepage is currently configured with hardcoded `http://shadowserver:*` links in [`services/core/config/homepage/services.yaml`](/Users/iyasin/Documents/code/projects/Homebase/services/core/config/homepage/services.yaml), while `.env` defaults `ROOT_URL` to `http://localhost`.

That means:

- `ROOT_URL` changes the URLs printed by `start.sh`
- `ROOT_URL` does not update Homepage links

If you are running this on a different host, update the Homepage links in [`services/core/config/homepage/services.yaml`](/Users/iyasin/Documents/code/projects/Homebase/services/core/config/homepage/services.yaml) to match your actual browser-facing hostname.

## First-Run Notes

- Portainer and Nextcloud will need their normal first-run setup in the browser
- Calibre Web should be pointed at `/books` as its library path
- Replace all default passwords before exposing any service beyond a trusted local network

## Additional Docs

- [docs/current.md](/Users/iyasin/Documents/code/projects/Homebase/docs/current.md): current repo state and known mismatches
- [docs/ops.md](/Users/iyasin/Documents/code/projects/Homebase/docs/ops.md): common operational commands
- [docs/services.md](/Users/iyasin/Documents/code/projects/Homebase/docs/services.md): service inventory and internal targets
