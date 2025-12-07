#!/bin/bash

# Deployment script for EC2 instance
# Usage: ./deploy.sh [EC2_IP] [EC2_USER]

EC2_IP=${1:-"98.84.25.68"}
EC2_USER=${2:-"ec2-user"}
IMAGE_NAME="ongets18/back-service:latest"
CONTAINER_NAME="back-service"
PORT=3000

echo "🚀 Deploying to EC2 instance: $EC2_IP"

# SSH into EC2 and deploy
ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP << EOF
  echo "📦 Logging into Docker Hub..."
  echo "\$DOCKER_HUB_TOKEN" | docker login -u ongets18 --password-stdin || exit 1
  
  echo "🔄 Pulling latest image..."
  docker pull $IMAGE_NAME || exit 1
  
  echo "🛑 Stopping existing container..."
  docker stop $CONTAINER_NAME 2>/dev/null || true
  docker rm $CONTAINER_NAME 2>/dev/null || true
  
  echo "✨ Starting new container..."
  docker run -d \\
    --name $CONTAINER_NAME \\
    --restart unless-stopped \\
    -p $PORT:3000 \\
    $IMAGE_NAME || exit 1
  
  echo "✅ Deployment complete!"
  echo "📊 Container status:"
  docker ps | grep $CONTAINER_NAME
  echo ""
  echo "🌐 Application should be available at: http://$EC2_IP:$PORT"
EOF

if [ \$? -eq 0 ]; then
  echo "✅ Deployment successful!"
else
  echo "❌ Deployment failed!"
  exit 1
fi

