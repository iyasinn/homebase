# Environment Configuration

This document explains where Docker Compose environment variables come from in this repo and which values are required before starting the stack.

## How Variable Loading Works

The repo starts services through [`start.sh`](/Users/iyasin/Documents/code/projects/Homebase/start.sh:1):

```bash
docker compose -f services/core/docker-compose.yml up -d
docker compose -f services/storage/docker-compose.yml up -d
```

Because those commands run from the Homebase repo root, Docker Compose looks for shell-exported variables and a root-level `.env` file in `~/homebase/`.

The compose files do not load `services/core/.env` or `services/storage/.env` automatically when launched this way.

## Required Variables

Create a root `.env` file next to `start.sh` and set these values:

```env
# services/core
UPTIME_KUMA_USERNAME=admin
UPTIME_KUMA_PASSWORD=change-me

# services/storage
NEXTCLOUD_DB_PASSWORD=change-me
NEXTCLOUD_DB_ROOT_PASSWORD=change-me
NEXTCLOUD_ADMIN_USER=admin
NEXTCLOUD_ADMIN_PASSWORD=change-me
```

You can use [`.env.example`](/Users/iyasin/Documents/code/projects/Homebase/.env.example:1) as the template.

## Where Each Variable Is Used

`services/core/docker-compose.yml`

- `UPTIME_KUMA_USERNAME`
- `UPTIME_KUMA_PASSWORD`

`services/storage/docker-compose.yml`

- `NEXTCLOUD_DB_PASSWORD`
- `NEXTCLOUD_DB_ROOT_PASSWORD`
- `NEXTCLOUD_ADMIN_USER`
- `NEXTCLOUD_ADMIN_PASSWORD`

## Common Failure Mode

If `.env` is missing, Docker Compose starts with blank values and prints warnings like:

```text
The "UPTIME_KUMA_USERNAME" variable is not set. Defaulting to a blank string.
```

That means Compose found the placeholder in the YAML file but did not find a matching value in the current shell or the root `.env`.

## Startup Prerequisite

Docker must be running before `./start.sh` works. If Docker Desktop or the Docker daemon is stopped, Compose fails with errors like:

```text
Cannot connect to the Docker daemon at unix:///Users/iyasin/.docker/run/docker.sock
```

In that case, start Docker first, then rerun `./start.sh`.
