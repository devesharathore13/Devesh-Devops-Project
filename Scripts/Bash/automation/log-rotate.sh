#!/bin/bash

set -euo pipefail

LOG_DIR="${1:-/var/log/app}"
RETENTION_DAYS=30
MAX_SIZE_MB=100

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Compress old logs
find "$LOG_DIR" -name "*.log" -type f -mtime +1 ! -name "*.gz" -exec gzip {} \;

# Delete old compressed logs
find "$LOG_DIR" -name "*.log.gz" -type f -mtime +$RETENTION_DAYS -delete

# Check for large log files
while IFS= read -r logfile; do
    size_mb=$(du -m "$logfile" | cut -f1)
    if [ "$size_mb" -gt "$MAX_SIZE_MB" ]; then
        log "Large log file detected: $logfile (${size_mb}MB)"
        # Truncate large files
        > "$logfile"
        log "Truncated $logfile"
    fi
done < <(find "$LOG_DIR" -name "*.log" -type f)

log "Log rotation completed"
