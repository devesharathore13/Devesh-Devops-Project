#!/bin/bash

set -euo pipefail

APP_NAME="${1:-myapp}"
IMAGE_NAME="${2:-deverathore13/node-api:latest}"
CONTAINER_PORT="${3:-3000}"
HOST_PORT="${4:-3000}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Pull latest image
log "Pulling latest image: $IMAGE_NAME"
docker pull "$IMAGE_NAME"

# Stop and remove old container
if docker ps -a --format '{{.Names}}' | grep -q "^${APP_NAME}$"; then
    log "Stopping existing container: $APP_NAME"
    docker stop "$APP_NAME" || true
    docker rm "$APP_NAME" || true
fi

# Start new container
log "Starting new container: $APP_NAME"
docker run -d \
    --name "$APP_NAME" \
    --restart unless-stopped \
    -p "$HOST_PORT:$CONTAINER_PORT" \
    -e NODE_ENV=production \
    "$IMAGE_NAME"

# Wait for health check
log "Waiting for application to be ready..."
sleep 5

# Verify container is running
if docker ps --format '{{.Names}}' | grep -q "^${APP_NAME}$"; then
    log "Deployment successful!"
    docker logs --tail 20 "$APP_NAME"
else
    log "ERROR: Container failed to start"
    docker logs "$APP_NAME"
    exit 1
fi

# Cleanup old images
log "Cleaning up old images..."
docker image prune -af --filter "until=24h"

log "Deployment completed"
