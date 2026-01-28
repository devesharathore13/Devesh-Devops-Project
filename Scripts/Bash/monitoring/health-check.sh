#!/bin/bash

set -euo pipefail

ENDPOINTS=(
    "https://api.example.com/health"
    "https://app.example.com/health"
)

SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"
LOG_FILE="/var/log/health-check.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

notify_slack() {
    local message="$1"
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST "$SLACK_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"$message\"}" 2>/dev/null
    fi
}

check_endpoint() {
    local url="$1"
    local response
    local http_code
    
    response=$(curl -s -w "\n%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" -eq 200 ]; then
        log "✓ $url is healthy (HTTP $http_code)"
        return 0
    else
        log "✗ $url is down or unhealthy (HTTP $http_code)"
        notify_slack "🚨 Alert: $url is down (HTTP $http_code)"
        return 1
    fi
}

log "Starting health checks..."

failed=0
for endpoint in "${ENDPOINTS[@]}"; do
    if ! check_endpoint "$endpoint"; then
        ((failed++))
    fi
done

if [ $failed -eq 0 ]; then
    log "All endpoints are healthy"
    exit 0
else
    log "$failed endpoint(s) failed health check"
    exit 1
fi
