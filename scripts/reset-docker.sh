#!/bin/bash
echo "=== Stopping all containers ==="
# If no containers exist, ignore error without exiting script
docker stop $(docker ps -aq) 2>/dev/null || true

echo "=== Deleting all containers ==="
docker rm $(docker ps -aq) 2>/dev/null || true

echo "=== Deleting all local images ==="
docker rmi $(docker images -q) 2>/dev/null || true

echo "=== Prune unused volumes and custom networks ==="
docker volume prune -f
docker network prune -f

echo -e "\n=== Docker environment fully cleared ==="
echo "Current containers (should be empty):"
docker ps -a
echo -e "\nCurrent local images (should be empty):"
docker images

