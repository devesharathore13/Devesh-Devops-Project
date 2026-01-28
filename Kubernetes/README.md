# Kubernetes Manifests

Production-grade K8s configurations for enterprise applications.

## Structure
```
├── Deployments/          # Application deployments
├── Services/             # Service definitions
├── Ingress/             # Ingress rules
├── StatefulSets/        # Stateful applications
├── DaemonSets/          # Node-level services
├── ConfigMaps-Secrets/  # Config & secrets
├── RBAC/                # Access control
├── Network-Policies/    # Network security
├── Storage/             # PV, PVC, StorageClass
├── HPA/                 # Auto-scaling
├── Jobs-CronJobs/       # Batch jobs
└── Helm/                # Helm charts
```

## Quick Deploy
```bash
kubectl apply -f Namespaces/
kubectl apply -f ConfigMaps-Secrets/
kubectl apply -f Deployments/
kubectl apply -f Services/
kubectl apply -f Ingress/
```

## Images Used
- deverathore13/nginx:latest
- deverathore13/node-api:v2.1
- deverathore13/react-app:prod
- deverathore13/postgres:14
- deverathore13/redis:7-alpine
