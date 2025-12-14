# EC2 Deployment Guide

## Quick Deploy Commands

SSH into your EC2 instance and run:

```bash
# 1. Login to Docker Hub
echo "YOUR_DOCKER_HUB_TOKEN" | docker login -u ongets18 --password-stdin

# 2. Pull the latest image
docker pull ongets18/back-service:latest

# 3. Stop and remove old container
docker stop back-service 2>/dev/null || true
docker rm back-service 2>/dev/null || true

# 4. Run the new container
docker run -d \
  --name back-service \
  --restart unless-stopped \
  -p 3000:3000 \
  ongets18/back-service:latest

# 5. Check if it's running
docker ps | grep back-service

# 6. Check logs
docker logs back-service
```

## Verify Deployment

After deployment, check the version:

```bash
# From your local machine
curl http://44.200.42.211:3000

# Check Swagger docs (should show version 1.1)
curl http://44.200.42.211:3000/api
```

## One-Line Deploy

If you have Docker Hub token set as environment variable on EC2:

```bash
echo "$DOCKER_HUB_TOKEN" | docker login -u ongets18 --password-stdin && \
docker pull ongets18/back-service:latest && \
docker stop back-service 2>/dev/null; docker rm back-service 2>/dev/null; \
docker run -d --name back-service --restart unless-stopped -p 3000:3000 ongets18/back-service:latest
```

