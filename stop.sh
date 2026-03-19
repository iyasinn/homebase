#!/bin/bash
# ~/homebase/stop.sh

# Core turns off last
docker compose -f services/storage/docker-compose.yml down

# Core turns off last
docker compose -f services/core/docker-compose.yml down
