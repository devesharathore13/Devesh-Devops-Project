# Ansible Configuration Management

Production-grade Ansible playbooks and roles for infrastructure automation.

## Structure
```
├── Playbooks/       # Main playbooks
├── Roles/           # Reusable roles
├── Inventory/       # Environment inventories
├── Group_vars/      # Group variables
├── Host_vars/       # Host variables
└── Templates/       # Jinja2 templates
```

## Usage

### Run full site deployment
```bash
ansible-playbook Playbooks/site.yml -i Inventory/prod/hosts.ini
```

### Deploy application
```bash
ansible-playbook Playbooks/deploy-app.yml
```

### Update systems
```bash
ansible-playbook Playbooks/update-system.yml
```

### Backup databases
```bash
ansible-playbook Playbooks/backup-databases.yml
```

### Security hardening
```bash
ansible-playbook Playbooks/security-hardening.yml
```

### Check syntax
```bash
ansible-playbook Playbooks/site.yml --syntax-check
```

### Dry run
```bash
ansible-playbook Playbooks/site.yml --check
```

### Run specific roles
```bash
ansible-playbook Playbooks/site.yml --tags "docker"
```

## Roles
- **webserver**: Nginx + Docker application deployment
- **database**: PostgreSQL with replication
- **docker**: Docker engine installation
- **kubernetes**: K8s cluster setup
- **monitoring**: Prometheus + Grafana

## Best Practices
✅ Idempotent playbooks
✅ Role-based organization
✅ Environment separation
✅ Secret management with Ansible Vault
✅ Template-based configuration
