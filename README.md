# CSE644 Docker Assignment Submission
## Basic Submission Info
Student Name: Wanling Jiang
GitHub Username: wanlingj-cse
GitHub Repository Link: https://github.com/wanlingj-cse/cse644-docker-assignment/tree/master
Docker Hub Username: wanlingj
Docker Hub Profile Link: https://hub.docker.com/u/wanlingj
Custom Nginx Web Image: https://hub.docker.com/repository/docker/wanlingj/cse644-nginx/general
Python HTTP Server Image: https://hub.docker.com/repository/docker/wanlingj/cse644-python-web/general
HAProxy Load Balancer Image: https://hub.docker.com/repository/docker/wanlingj/cse644-haproxy/general

## Project Overview
This assignment demonstrates core Docker concepts including custom image building, multi-container deployment, three Docker network modes (bridge / host / none), persistent volume storage, and HAProxy load balancing for Nginx web servers.
All source Dockerfiles, application code, configuration files, and lab evidence screenshots/logs are contained within this repository.
## 1. Repository File Structure
├── README.md                     # Assignment documentation (this file)
├── cse644-web-custom/            # Custom Nginx static web image
│   ├── Dockerfile
│   └── index.html                # Custom personalized web page
├── cse644-python-web/            # Python simple HTTP server image
│   ├── Dockerfile
│   └── app.py                    # Python web source code
├── cse644-haproxy-nginx/         # HAProxy load balancer config
│   ├── Dockerfile
│   └── haproxy.cfg               # Routing config to backend Nginx containers
├── scripts/                      # Automatic build, push, reset scripts
│   ├── build-all-images.sh       # Build 3 custom Docker images at once
│   ├── push-images-dockerhub.sh  # Tag and upload images to Docker Hub
│   └── reset-docker.sh           # Wipe all containers, images, volumes, networks
├── CSE644_HW1_WanlingJiang.pdf   # All the evidence screenshots and terminal logs

## 2. Pre-Lab: Full Docker Environment Reset (Start from Empty)
Before demonstrating all lab steps, clear all existing Docker resources to a blank environment.
### Run script: reset-docker.sh:
chmod +x scripts/reset-docker.sh
bash scripts/reset-docker.sh

## 3. Step 1: Build All 3 Custom Docker Images (Evidence in Part 4,5,6 of CSE644_HW1_WanlingJiang.pdf)
### Run Script: build-all-images.sh
chmod +x scripts/build-all-images.sh
bash scripts/build-all-images.sh

## 4. Step 2: Persistent Volume Demonstration (Evidence in Part 8 of CSE644_HW1_WanlingJiang.pdf)
```bash
# 1. Create a persistent named volume
docker volume create web-persist-volume

# 2. Start Nginx container mounted to the volume
docker run -d --name volume-test -v web-persist-volume:/usr/share/nginx/html wanlingj/cse644-custom-nginx

# 3. Write test file into persistent storage
docker exec -it volume-test bash -c "echo Persistent_Data_Test > /usr/share/nginx/html/storage-check.txt"

# 4. Delete the running container
docker rm -f volume-test

# 5. Recreate new container with the same volume mount
docker run -d --name volume-test -v web-persist-volume:/usr/share/nginx/html wanlingj/cse644-custom-nginx

# 6. Verify the test file still exists (proof of persistence)
docker exec volume-test cat /usr/share/nginx/html/storage-check.txt
```

## 5. Step 3: Three Docker Network Mode Demonstrations (Evidence in Part 9 of CSE644_HW1_WanlingJiang.pdf)
### 5.1 Bridge Network (Default isolated container network)
Custom bridge network allows inter-container communication via container hostname, isolated from host external network by default.
```bash
# Create dedicated custom bridge network
docker network create cse-bridge-net

# Launch two Nginx backend containers attached to this bridge
docker run -d --name nginx-bridge-1 --network cse-bridge-net wanlingj/cse644-custom-nginx
docker run -d --name nginx-bridge-2 --network cse-bridge-net wanlingj/cse644-custom-nginx

# Start a test client container to send curl request to Nginx by container name
docker run -it --name bridge-client --network cse-bridge-net ubuntu:24.04 bash -c "apt update && apt install curl -y; curl nginx-bridge-1:80"
```
Note: Since we removed all images including ubuntu:24.04 locally, it will pull from library/ubuntu, then show the CSE644 Custom Nginx Web Page.

### 5.2 Host Network (--network host, share host full network stack)
Container directly uses Vagrant VM’s network interface, no port mapping needed, can access host local ports.
```bash
# Start utility container with host network mode
docker run -d --name host-net-demo --network host ubuntu:24.04 bash -c "apt update && apt install iproute2 curl iputils-ping -y; sleep infinity"

# Enter interactive exec session inside host-mode container
docker exec -it host-net-demo bash

# Test commands inside container:
ip a
ping 8.8.8.8

# Then, exit
exit
```
Note: If it shows ip not found, then install using:
```bash
apt update && apt install iproute2 -y
```

## 5.3 Isolated None Network (zero network access)
No network interfaces attached, cannot reach internet, host or other containers.
```bash
# Create fully isolated container
docker run -it --name none-net-demo --network none ubuntu:24.04 bash

# Inside container run test:
cat /proc/net/dev # Only one device named `lo` (loopback), NO eth0 or any real network card.

# Then exit
exit
```
To show ping or ip commands for clearer demonstration, we can:
```bash
# First remove none-net-demo:
docker rm none-net-demo
# Create temporary container with network to install tools
docker run -it --name temp-build ubuntu:24.04 bash
# Inside temp container
apt update && apt install iproute2 iputils-ping -y
# Exit, save as new image
exit
docker commit temp-build ubuntu-nettools
# Launch isolated container from this image
docker run -it --name none-net-demo --network none ubuntu-nettools bash
# Now we can use ip a and ping commands
ip a  # Only one device named `lo` (loopback), NO eth0 or any real network card.
ping 8.8.8.8 # This command shows network is unreachable
# Finally, exit
exit
```

## 6. Step 4: HAProxy Load Balancer Proxy to Nginx Backends (Evidence is in Part 7 of CSE644_HW1_WanlingJiang.pdf)
HAProxy distributes HTTP traffic across multiple Nginx web containers as backend servers.
```bash
# Create custom bridge network
docker network create proxy-net

# Start backend containers with names web1 / web2 (matches haproxy.cfg)
docker run -d --name web1 --network proxy-net wanlingj/cse644-custom-nginx
docker run -d --name web2 --network proxy-net wanlingj/cse644-custom-nginx

# Start HAProxy proxy container, map host port 8080
docker run -d --name haproxy-lb -p 8080:80 --network proxy-net wanlingj/cse644-haproxy

# Test load balancing request from host terminal
curl localhost:8080
```

## 7. Step 5: Push Custom Images to Docker Hub (Evidence is in Part 10 of CSE644_HW1_WanlingJiang.pdf)
Use script: scripts/push-images-dockerhub.sh
```bash
chmod +x scripts/push-images-dockerhub.sh
bash scripts/push-images-dockerhub.sh
```

## 8. Step 6: Upload All Assignment Files to GitHub (Evidence is in Part 12 of CSE644_HW1_WanlingJiang.pdf)
After finishing all lab demonstrations and collecting all evidence screenshots, upload all project files to GitHub repository.
```bash
# Stage only assignment required files, exclude system hidden junk files
git add cse644-web-custom/ cse644-python-web/ cse644-haproxy-nginx/ scripts/ README.md CSE644_HW1_WanlingJiang.pdf

# Create clean commit without sensitive system files
git commit -m "Docker assignment: source code, configs, scripts and lab evidence"

# Push commit to GitHub remote master branch
git push origin master
```
