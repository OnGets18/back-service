#!/bin/bash

# Commands to run in EC2 Instance Connect to check deployment status

echo "=== Check Docker Status ==="
echo "sudo systemctl status docker"
echo ""
echo "=== Check if container is running ==="
echo "docker ps -a"
echo ""
echo "=== Check Docker Hub login ==="
echo "docker login -u ongets18"
echo ""
echo "=== Pull latest image ==="
echo "docker pull ongets18/back-service:latest"
echo ""
echo "=== Check current container ==="
echo "docker ps | grep back-service"
echo ""
echo "=== View container logs ==="
echo "docker logs back-service"
echo ""
echo "=== Restart container ==="
echo "docker stop back-service 2>/dev/null; docker rm back-service 2>/dev/null; docker run -d --name back-service --restart unless-stopped -p 3000:3000 ongets18/back-service:latest"


