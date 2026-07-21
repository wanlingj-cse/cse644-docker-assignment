#!/bin/bash
set -e
DOCKERHUB_USER=wanlingj
echo "==== Start building all assignment images ===="

# Build customized Nginx image
echo -e "\\n1. Build Custom Nginx Web Image"
docker build -t ${DOCKERHUB_USER}/cse644-custom-nginx ./cse644-web-custom

# Build Python HTTP server image
echo -e "\\n2. Build Python Web Server Image"
docker build -t ${DOCKERHUB_USER}/cse644-python-web ./cse644-python-web

# Build HAProxy load balancer image
echo -e "\\n3. Build HAProxy Nginx Proxy Image"
docker build -t ${DOCKERHUB_USER}/cse644-haproxy ./cse644-haproxy-nginx

echo -e "\\n==== All images built successfully ===="
docker images | grep ${DOCKERHUB_USER}
