#!/bin/bash
# ~/homebase/stop.sh

docker compose -f ai/docker-compose.yml down
docker compose -f storage/docker-compose.yml down

# Core turns off last
docker compose -f core/docker-compose.yml down
