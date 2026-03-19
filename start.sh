#!/bin/bash
# ~/homebase/start.sh

echo "Starting core services..."
docker compose -f services/core/docker-compose.yml up -d

echo "Starting storage services..."
docker compose -f services/storage/docker-compose.yml up -d

echo "Done!"
