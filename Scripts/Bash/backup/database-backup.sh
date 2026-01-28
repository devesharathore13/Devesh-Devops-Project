#!/bin/bash

set -euo pipefail

# Configuration
BACKUP_DIR="/backup/databases"
RETENTION_DAYS=7
DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/db-backup.log"

# Database credentials
DB_HOST="${DB_HOST:-localhost}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="${DB_NAME:-appdb}"
PGPASSWORD="${DB_PASSWORD}"
export PGPASSWORD

# S3 Configuration (optional)
S3_BUCKET="${S3_BUCKET:-}"
AWS_REGION="${AWS_REGION:-us-east-1}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error_exit() {
    log "ERROR: $1"
    exit 1
}

# Create backup directory
mkdir -p "$BACKUP_DIR" || error_exit "Failed to create backup directory"

# Backup filename
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"

log "Starting database backup for $DB_NAME"

# Perform backup
if pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"; then
    log "Backup completed: $BACKUP_FILE"
    log "Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"
else
    error_exit "Backup failed"
fi

# Upload to S3 if configured
if [ -n "$S3_BUCKET" ]; then
    log "Uploading backup to S3..."
    if aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/databases/" --region "$AWS_REGION"; then
        log "Successfully uploaded to S3"
    else
        log "WARNING: S3 upload failed"
    fi
fi

# Cleanup old backups
log "Cleaning up backups older than $RETENTION_DAYS days"
find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -type f -mtime +$RETENTION_DAYS -delete

# Verify backup
if [ -f "$BACKUP_FILE" ]; then
    if gunzip -t "$BACKUP_FILE" 2>/dev/null; then
        log "Backup verification successful"
    else
        error_exit "Backup verification failed"
    fi
fi

log "Backup process completed successfully"
