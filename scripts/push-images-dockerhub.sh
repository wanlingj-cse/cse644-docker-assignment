#!/bin/bash
set -e
DOCKERHUB_USER=wanlingj
echo "=== Login to Docker Hub ==="
docker login
echo "=== Start pushing built images ==="
docker push ${DOCKERHUB_USER}/cse644-custom-nginx
docker push ${DOCKERHUB_USER}/cse644-python-web
docker push ${DOCKERHUB_USER}/cse644-haproxy
echo "=== All images uploaded to Docker Hub successfully ==="
