#!/bin/bash
# ~/homebase/start.sh

ROOT_URL="http://localhost"

if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

if docker network inspect homebase >/dev/null 2>&1; then
  echo "Docker network 'homebase' already exists."
else
  docker network create homebase >/dev/null
  echo "Docker network 'homebase' created."
fi

echo "Starting core services:"
echo "  Homepage: ${ROOT_URL}:3000"
echo "  Uptime Kuma: ${ROOT_URL}:3001"
echo "  Portainer: ${ROOT_URL}:9443"
echo "  Dozzle: ${ROOT_URL}:9999"
echo "  Duplicati: ${ROOT_URL}:8200"
echo "  Nginx Proxy Manager: ${ROOT_URL}:81"
docker compose --env-file .env -f services/core/docker-compose.yml up -d

echo "Starting storage services:"
echo "  Nextcloud: ${ROOT_URL}:8080"
echo "  Calibre Web: ${ROOT_URL}:8083"
docker compose --env-file .env -f services/storage/docker-compose.yml up -d

echo "Done!"
