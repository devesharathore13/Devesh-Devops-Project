#!/bin/bash

set -euo pipefail

SOURCE_DIR="${1:-/var/www}"
BACKUP_DIR="${2:-/backup/files}"
RETENTION_DAYS=14
DATE=$(date +%Y%m%d_%H%M%S)

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/backup_${DATE}.tar.gz"

log "Starting backup of $SOURCE_DIR"

tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='*.log'

log "Backup completed: $BACKUP_FILE"
log "Size: $(du -h "$BACKUP_FILE" | cut -f1)"

# Cleanup old backups
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete

log "Old backups cleaned up"
