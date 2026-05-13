# Services Overview

This document gives a short technical summary of each service in the Homebase stack.

## Core Services

### Homepage

Dashboard UI for the local stack. It provides one landing page with links to the rest of the services.

Local URL: `http://localhost:3000`

### Uptime Kuma

Monitoring service. It checks whether your apps are reachable and can alert you when something goes down.

Local URL: `http://localhost:3001`

### Portainer

Docker management UI. It is useful for inspecting containers, viewing logs, checking resource usage, and restarting services.

Local URL: `https://localhost:9443`

### Dozzle

Live Docker log viewer. It provides a lightweight web UI for streaming container logs in real time.

Local URL: `http://localhost:9999`

### Duplicati

Backup service. It is used to back up selected directories to a target backup location.

Local URL: `http://localhost:8200`

### Nginx Proxy Manager

Reverse proxy management UI. It is used for host-based routing, TLS certificates, and exposing services behind friendly domains later.

Local URL: `http://localhost:81`

### Autokuma

Helper service for Uptime Kuma. It can read Docker container labels and automatically register monitors in Uptime Kuma.

No direct UI.

## Storage Services

### Nextcloud

Self-hosted file sync and sharing platform. It is the main user-facing storage application in this stack.

Local URL: `http://localhost:8080`

### nextcloud-db

MariaDB database for Nextcloud. It stores application state, metadata, and account information.

No direct UI.

### nextcloud-redis

Redis cache for Nextcloud. It improves performance and supports file locking behavior.

No direct UI.

## Disabled Services

### Syncthing

Currently commented out in `services/storage/docker-compose.yml`. If re-enabled, it would provide peer-to-peer file synchronization.
