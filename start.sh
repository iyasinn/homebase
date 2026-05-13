#!/bin/bash
# ~/homebase/start.sh

echo "Starting core services..."
docker compose --env-file .env -f services/core/docker-compose.yml up -d

echo "Starting storage services..."
docker compose --env-file .env -f services/storage/docker-compose.yml up -d

echo "Done!"
