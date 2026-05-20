# Services

## Core

- `Homepage`: dashboard at `http://shadowserver:3000`
- `Portainer`: Docker UI at `https://shadowserver:9443`
- `Uptime Kuma`: monitoring UI at `http://shadowserver:3001`
- `Autokuma`: auto-registers monitors from Docker labels
- `Dozzle`: container logs at `http://shadowserver:9999`
- `Duplicati`: backup UI at `http://shadowserver:8200`
- `Nginx Proxy Manager`: reverse proxy UI at `http://shadowserver:81`

## Storage

- `Nextcloud`: file app at `http://shadowserver:8080`
- `Collabora`: online office suite for Nextcloud at `http://shadowserver:9980`
- `Calibre Web`: ebook library at `http://shadowserver:8083`
- `nextcloud-db`: MariaDB for Nextcloud
- `nextcloud-redis`: Redis for Nextcloud

## Internal Targets

Use these for service-to-service checks, not browser links:

- `http://homepage:3000`
- `https://portainer:9443`
- `http://dozzle:8080`
- `http://duplicati:8200`
- `http://nextcloud:80`
- `http://collabora:9980`
- `http://calibre-web:8083`
