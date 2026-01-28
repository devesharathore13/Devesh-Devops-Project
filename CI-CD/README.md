# CI/CD Pipelines

Enterprise-grade CI/CD configurations for multi-cloud deployments.

## Tools Covered
- **Jenkins**: Kubernetes agents, shared libraries, JobDSL
- **GitHub Actions**: Reusable workflows, composite actions
- **GitLab CI**: Templates, multi-stage pipelines
- **Argo CD**: GitOps, ApplicationSets, multi-cluster

## Quick Start

### Jenkins
```bash
docker run -p 8080:8080 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

### Argo CD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f Argo-CD/Applications/
```

## Best Practices
✅ Multi-stage builds
✅ Caching strategies
✅ Security scanning
✅ GitOps workflows
✅ Progressive delivery
