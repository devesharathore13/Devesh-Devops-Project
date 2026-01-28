# Monitoring & Logging Stack

Complete observability solution with Prometheus, Grafana, ELK, and Loki.

## Structure
```
├── Prometheus/       # Metrics collection
├── Grafana/          # Visualization
├── ELK-Stack/        # Log aggregation
└── Loki/             # Log aggregation (lightweight)
```

## Quick Start

### Full Stack
```bash
docker-compose -f docker-compose-full-stack.yml up -d
```

### Individual Stacks
```bash
# Prometheus + Grafana
cd Prometheus/exporters && docker-compose up -d

# ELK Stack
cd ELK-Stack && docker-compose up -d

# Loki
cd Loki && docker-compose up -d
```

## Access URLs
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Prometheus**: http://localhost:9090
- **Kibana**: http://localhost:5601
- **Alertmanager**: http://localhost:9093

## Features
✅ Real-time metrics with Prometheus
✅ Beautiful dashboards with Grafana
✅ Centralized logging with ELK/Loki
✅ Alert management
✅ Docker & Kubernetes monitoring
✅ Application performance monitoring

## Exporters
- **Node Exporter**: System metrics
- **cAdvisor**: Container metrics
- **Blackbox**: Endpoint monitoring

## Monitoring Targets
- Infrastructure (CPU, Memory, Disk)
- Applications (HTTP, errors, latency)
- Databases (PostgreSQL, MySQL)
- Kubernetes clusters
- Docker containers
