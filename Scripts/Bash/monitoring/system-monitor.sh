#!/bin/bash

set -euo pipefail

CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

alert() {
    log "ALERT: $*"
}

# Check CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
cpu_usage_int=${cpu_usage%.*}

if [ "$cpu_usage_int" -gt "$CPU_THRESHOLD" ]; then
    alert "High CPU usage: ${cpu_usage}%"
fi

# Check memory usage
memory_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')

if [ "$memory_usage" -gt "$MEMORY_THRESHOLD" ]; then
    alert "High memory usage: ${memory_usage}%"
fi

# Check disk usage
while IFS= read -r line; do
    usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    mount=$(echo "$line" | awk '{print $6}')
    
    if [ "$usage" -gt "$DISK_THRESHOLD" ]; then
        alert "High disk usage on $mount: ${usage}%"
    fi
done < <(df -h | grep -vE '^Filesystem|tmpfs|cdrom')

log "System monitoring completed"
