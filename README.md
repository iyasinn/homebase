# Homebase

Homebase is a small self-hosted homelab split across two Docker Compose stacks:

- `services/core`: dashboarding, monitoring, logs, backups, and Docker admin
- `services/storage`: file storage, ebook library, and the services Nextcloud depends on

The repo keeps hand-managed config in Git and leaves runtime data in local `volumes/` directories.

## At A Glance

### Core

- Homepage
- Portainer
- Uptime Kuma
- Autokuma
- Dozzle
- Duplicati
- Nginx Proxy Manager

### Storage

- Nextcloud
- Calibre Web
- MariaDB
- Redis

Some extra services are present in the compose files but commented out.

## Quick Start

1. Copy the example env file:

   ```bash
   cp .env.example .env
   ```

2. Set the required values in `.env`:

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

3. Review host bind mounts before first run.

   `Duplicati` currently expects:

   - `~/homebase-backups` mounted to `/backups`
   - `~/homebase` mounted to `/source/homebase:ro`

   If that does not match your machine, update [`services/core/docker-compose.yml`](/Users/iyasin/Documents/code/projects/Homebase/services/core/docker-compose.yml).

4. Start everything:

   ```bash
   ./start.sh
   ```

`start.sh` loads `.env`, creates the external Docker network `homebase` if needed, then starts both compose stacks.

## Default Local URLs

If `ROOT_URL=http://localhost`, these are the browser entry points:

- Homepage: `http://localhost:3000`
- Uptime Kuma: `http://localhost:3001`
- Portainer: `https://localhost:9443`
- Dozzle: `http://localhost:9999`
- Duplicati: `http://localhost:8200`
- Nginx Proxy Manager: `http://localhost:81`
- Nextcloud: `http://localhost:8080`
- Calibre Web: `http://localhost:8083`

## Common Commands

Start both stacks:

```bash
./start.sh
```

Stop both stacks:

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

## How The Repo Is Organized

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

- `config/` is for files you are expected to edit directly
- `volumes/` is for persistent app data and is ignored by Git
- the root `.env` file is shared by both compose stacks

## Operational Notes

- Both compose files attach to the same external Docker network: `homebase`
- Required env vars use `${VAR:?message}` checks, so missing values fail fast
- Browser-facing URLs and container-to-container URLs are different
- Internal service checks should use Docker names like `homepage`, `nextcloud`, and `portainer`

## Caveats

Homepage links are currently hardcoded to `http://shadowserver:*` in [`services/core/config/homepage/services.yaml`](/Users/iyasin/Documents/code/projects/Homebase/services/core/config/homepage/services.yaml), while `.env.example` defaults `ROOT_URL` to `http://localhost`.

That means:

- `ROOT_URL` changes the URLs printed by `start.sh`
- `ROOT_URL` does not update Homepage links

If you run this on a different host, update [`services/core/config/homepage/services.yaml`](/Users/iyasin/Documents/code/projects/Homebase/services/core/config/homepage/services.yaml) to match your real browser-facing hostname.

## First Run

- Portainer and Nextcloud still need their normal in-browser setup
- Calibre Web should use `/books` as its library path
- Replace default passwords before exposing anything beyond a trusted network

## More Detail

- [docs/current.md](/Users/iyasin/Documents/code/projects/Homebase/docs/current.md) for the current repo state and known mismatches
- [docs/ops.md](/Users/iyasin/Documents/code/projects/Homebase/docs/ops.md) for operational commands
- [docs/services.md](/Users/iyasin/Documents/code/projects/Homebase/docs/services.md) for the full service inventory
