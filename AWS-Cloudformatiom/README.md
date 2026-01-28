# AWS CloudFormation Templates

Production-ready IaC templates for AWS infrastructure.

## Structure
```
├── VPC/                 # Network infrastructure
├── EC2/                 # Compute instances
├── RDS/                 # Databases
├── S3/                  # Storage & CDN
├── Lambda/              # Serverless functions
├── ECS-Fargate/         # Container orchestration
├── EKS/                 # Kubernetes clusters
├── IAM/                 # Access management
├── Nested-Stacks/       # Modular deployments
└── ALB-NLB/            # Load balancers
```

## Deploy
```bash
# Create VPC
aws cloudformation create-stack \
  --stack-name production-vpc \
  --template-body file://VPC/vpc-with-subnets.yaml

# Create RDS
aws cloudformation create-stack \
  --stack-name production-rds \
  --template-body file://RDS/postgres-rds.yaml \
  --parameters ParameterKey=DBPassword,ParameterValue=YourPassword123

# Create ECS
aws cloudformation create-stack \
  --stack-name production-ecs \
  --template-body file://ECS-Fargate/ecs-cluster.yaml \
  --capabilities CAPABILITY_IAM
```

## Validation
```bash
aws cloudformation validate-template --template-body file://VPC/vpc-with-subnets.yaml
```
