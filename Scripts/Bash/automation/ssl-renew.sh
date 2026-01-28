#!/bin/bash

set -euo pipefail

DOMAINS=("example.com" "www.example.com" "api.example.com")
EMAIL="admin@example.com"
WEBROOT="/var/www/html"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

for domain in "${DOMAINS[@]}"; do
    log "Renewing certificate for $domain"
    
    certbot renew \
        --webroot \
        -w "$WEBROOT" \
        -d "$domain" \
        --email "$EMAIL" \
        --agree-tos \
        --non-interactive \
        --quiet
done

# Reload nginx
if systemctl is-active --quiet nginx; then
    log "Reloading nginx"
    systemctl reload nginx
fi

log "SSL renewal completed"
