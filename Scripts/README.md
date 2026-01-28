# DevOps Scripts Collection

Production-ready automation scripts for DevOps workflows.

## Structure
```
├── Bash/
│   ├── backup/          # Database & file backups
│   ├── deployment/      # Deployment automation
│   ├── monitoring/      # Health checks & monitoring
│   ├── automation/      # General automation
│   └── system-admin/    # System administration
└── Python/
    ├── api-clients/     # K8s, Docker, AWS clients
    ├── automation/      # Infrastructure automation
    ├── data-processing/ # Log processing, metrics
    └── devops-tools/    # Custom DevOps utilities
```

## Bash Scripts

### Backup
```bash
# Database backup
./Bash/backup/database-backup.sh

# Directory backup
./Bash/backup/directory-backup.sh /var/www /backup/files
```

### Deployment
```bash
# Docker deployment
./Bash/deployment/docker-deploy.sh myapp deverathore13/api:latest

# Kubernetes deployment
./Bash/deployment/k8s-deploy.sh production api-deployment deverathore13/api:v1
```

### Monitoring
```bash
# Health checks
./Bash/monitoring/health-check.sh

# System monitoring
./Bash/monitoring/system-monitor.sh
```

## Python Scripts

### Requirements
```bash
pip install kubernetes docker paramiko boto3 requests
```

### Kubernetes Client
```bash
python Python/api-clients/kubernetes_client.py
```

### Docker Manager
```bash
python Python/api-clients/docker_client.py
```

## Cron Jobs

### Daily backup
```cron
0 2 * * * /path/to/database-backup.sh >> /var/log/backup.log 2>&1
```

### Hourly health check
```cron
0 * * * * /path/to/health-check.sh >> /var/log/health.log 2>&1
```

### Weekly SSL renewal
```cron
0 0 * * 0 /path/to/ssl-renew.sh >> /var/log/ssl.log 2>&1
```

## Best Practices
✅ Error handling with set -euo pipefail
✅ Logging with timestamps
✅ Exit codes for automation
✅ Configuration via environment variables
✅ Retention policies for backups
