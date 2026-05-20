# Ops

## Start

```bash
./start.sh
```

What it does:
- loads `.env`
- ensures Docker network `homebase` exists
- starts `services/core`
- starts `services/storage`

## Stop

```bash
./stop.sh
```

## Required Env

```env
ROOT_URL=http://localhost
UPTIME_KUMA_USERNAME=
UPTIME_KUMA_PASSWORD=
DUPLICATI_SETTINGS_ENCRYPTION_KEY=
DUPLICATI_PASSWORD=
NEXTCLOUD_DB_PASSWORD=
NEXTCLOUD_DB_ROOT_PASSWORD=
NEXTCLOUD_ADMIN_USER=
NEXTCLOUD_ADMIN_PASSWORD=
COLLABORA_USERNAME=
COLLABORA_PASSWORD=
```

## Optional Env

```env
COLLABORA_NEXTCLOUD_URL=
COLLABORA_EXTRA_PARAMS=
```

## Compose Failure Policy

Missing required env vars cause compose to fail immediately.

## Common Commands

```bash
docker compose --env-file .env -f services/core/docker-compose.yml ps
docker compose --env-file .env -f services/storage/docker-compose.yml ps
docker compose --env-file .env -f services/core/docker-compose.yml restart homepage
docker compose --env-file .env -f services/core/docker-compose.yml up -d --force-recreate duplicati
docker compose --env-file .env -f services/storage/docker-compose.yml up -d calibre-web
docker logs homepage
docker logs calibre-web
docker logs duplicati
docker logs nextcloud
docker logs collabora
```

## Notes

- Homepage links are browser-facing and currently point to `shadowserver`
- Uptime Kuma monitor targets should use internal Docker hostnames
- If you change `.env`, recreate the affected container when needed
- If Collabora is behind Nginx Proxy Manager with HTTPS, set `COLLABORA_EXTRA_PARAMS=--o:ssl.enable=false --o:ssl.termination=true`
- On first run, configure Calibre Web to use `/books` as the library path
