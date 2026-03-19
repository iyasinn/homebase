#!/bin/bash
# ~/homebase/start.sh

echo "Starting core services..."
docker compose -f core/docker-compose.yml up -d

echo "Starting storage services..."
docker compose -f storage/docker-compose.yml up -d

echo "Starting ai services..."
docker compose -f ai/docker-compose.yml up -d

echo "Done!"
