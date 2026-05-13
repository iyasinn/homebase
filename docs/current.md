# Current State

## Layout

```text
homebase/
  start.sh
  stop.sh
  .env
  .env.example
  services/
    core/
      docker-compose.yml
      config/
      volumes/
    storage/
      docker-compose.yml
      config/
      volumes/
```

Rules:
- `config/` = hand-managed config
- `volumes/` = persistent app state

## Stack Split

`services/core`
- Homepage
- Portainer
- Uptime Kuma
- Autokuma
- Dozzle
- Duplicati
- Nginx Proxy Manager

`services/storage`
- Nextcloud
- nextcloud-db
- nextcloud-redis
- Syncthing is disabled

## Networking

- Both compose files use the external Docker network `homebase`
- `start.sh` creates the network if missing

## Env Model

- Root `.env` is the source of truth
- `start.sh` runs both compose files with `--env-file .env`
- Required vars fail fast in compose

## Browser URLs

- Homepage config currently uses `shadowserver`
- Browser-facing links use host ports
- Container-to-container traffic uses Docker names like `nextcloud` and `homepage`

## Known Mismatch

- `ROOT_URL` in `.env.example` defaults to `http://localhost`
- Homepage links are currently hardcoded to `http://shadowserver:*`
- `ROOT_URL` affects `start.sh` console output, not Homepage config
