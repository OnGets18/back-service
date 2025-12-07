#!/bin/bash

# Automated deployment script for EC2
# Usage: ./deploy-to-ec2.sh [EC2_IP] [EC2_USER] [SSH_KEY_PATH]

set -e  # Exit on error

# Configuration
EC2_IP=${1:-"98.84.25.68"}
EC2_USER=${2:-"ec2-user"}
SSH_KEY=${3:-""}
IMAGE_NAME="ongets18/back-service:latest"
CONTAINER_NAME="back-service"
PORT=3000

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting deployment to EC2...${NC}"
echo -e "${BLUE}📍 Target: ${EC2_USER}@${EC2_IP}${NC}"
echo ""

# Check if Docker Hub token is set
if [ -z "$DOCKER_HUB_TOKEN" ]; then
  echo -e "${YELLOW}⚠️  DOCKER_HUB_TOKEN environment variable not set${NC}"
  echo -e "${YELLOW}Please set it with: export DOCKER_HUB_TOKEN='your_token'${NC}"
  read -sp "Or enter your Docker Hub token now: " DOCKER_HUB_TOKEN
  echo ""
fi

if [ -z "$DOCKER_HUB_TOKEN" ]; then
  echo -e "${RED}❌ Docker Hub token is required${NC}"
  exit 1
fi

# Build SSH command
SSH_CMD="ssh"
if [ -n "$SSH_KEY" ]; then
  SSH_CMD="$SSH_CMD -i $SSH_KEY"
fi
SSH_CMD="$SSH_CMD -o StrictHostKeyChecking=no -o ConnectTimeout=10"

echo -e "${BLUE}📡 Connecting to EC2 instance...${NC}"

# Test SSH connection
if ! $SSH_CMD $EC2_USER@$EC2_IP "echo 'Connection successful'" > /dev/null 2>&1; then
  echo -e "${RED}❌ Failed to connect to EC2 instance${NC}"
  echo -e "${YELLOW}Make sure:${NC}"
  echo "  1. EC2 instance is running"
  echo "  2. Security group allows SSH (port 22)"
  echo "  3. SSH key is correct (if using)"
  exit 1
fi

echo -e "${GREEN}✅ Connected to EC2${NC}"
echo ""

# Deploy
echo -e "${BLUE}📦 Deploying application...${NC}"

$SSH_CMD $EC2_USER@$EC2_IP << EOF
  set -e
  
  echo "🔐 Logging into Docker Hub..."
  echo "$DOCKER_HUB_TOKEN" | docker login -u ongets18 --password-stdin > /dev/null 2>&1 || {
    echo "❌ Docker Hub login failed"
    exit 1
  }
  
  echo "📥 Pulling latest image..."
  docker pull $IMAGE_NAME || {
    echo "❌ Failed to pull image"
    exit 1
  }
  
  echo "🛑 Stopping existing container..."
  docker stop $CONTAINER_NAME 2>/dev/null || true
  docker rm $CONTAINER_NAME 2>/dev/null || true
  
  echo "✨ Starting new container..."
  docker run -d \\
    --name $CONTAINER_NAME \\
    --restart unless-stopped \\
    -p $PORT:3000 \\
    $IMAGE_NAME || {
    echo "❌ Failed to start container"
    exit 1
  }
  
  echo "⏳ Waiting for container to start..."
  sleep 3
  
  echo "📊 Container status:"
  docker ps | grep $CONTAINER_NAME || {
    echo "⚠️  Container not found in running containers"
    echo "📋 Recent logs:"
    docker logs --tail 20 $CONTAINER_NAME 2>&1 || true
    exit 1
  }
  
  echo ""
  echo "📋 Container logs (last 10 lines):"
  docker logs --tail 10 $CONTAINER_NAME
EOF

if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✅ Deployment successful!${NC}"
  echo ""
  echo -e "${BLUE}🌐 Application URLs:${NC}"
  echo -e "   API: ${GREEN}http://${EC2_IP}:${PORT}${NC}"
  echo -e "   Swagger: ${GREEN}http://${EC2_IP}:${PORT}/api${NC}"
  echo ""
  echo -e "${BLUE}🔍 Verify deployment:${NC}"
  echo -e "   curl http://${EC2_IP}:${PORT}"
  echo ""
else
  echo ""
  echo -e "${RED}❌ Deployment failed!${NC}"
  exit 1
fi

