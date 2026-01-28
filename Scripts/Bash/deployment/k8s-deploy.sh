#!/bin/bash

set -euo pipefail

NAMESPACE="${1:-production}"
DEPLOYMENT="${2:-api-deployment}"
IMAGE="${3:-deverathore13/node-api:latest}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Check kubectl connection
if ! kubectl cluster-info &>/dev/null; then
    echo "ERROR: Cannot connect to Kubernetes cluster"
    exit 1
fi

log "Deploying $IMAGE to $NAMESPACE"

# Update deployment image
kubectl set image deployment/"$DEPLOYMENT" \
    "*=$IMAGE" \
    -n "$NAMESPACE" \
    --record

log "Waiting for rollout to complete..."
if kubectl rollout status deployment/"$DEPLOYMENT" -n "$NAMESPACE" --timeout=5m; then
    log "Deployment successful!"
else
    log "ERROR: Deployment failed"
    kubectl rollout undo deployment/"$DEPLOYMENT" -n "$NAMESPACE"
    exit 1
fi

# Get deployment info
kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE"
kubectl get pods -n "$NAMESPACE" -l app="$DEPLOYMENT"

log "Deployment completed successfully"
