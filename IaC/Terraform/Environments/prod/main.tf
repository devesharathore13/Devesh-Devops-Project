terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "Terraform"
      Project     = "Infrastructure"
    }
  }
}

module "networking" {
  source = "../../Modules/networking"

  environment          = "production"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway   = true

  common_tags = {
    Environment = "production"
  }
}

module "eks" {
  source = "../../AWS/EKS"

  environment         = "production"
  kubernetes_version  = "1.28"
  instance_types      = ["t3.large"]
  desired_size        = 3
  max_size            = 10
  min_size            = 2
  public_subnet_ids   = module.networking.public_subnet_ids
  private_subnet_ids  = module.networking.private_subnet_ids
}

module "rds" {
  source = "../../AWS/RDS"

  environment           = "production"
  instance_class        = "db.r6g.xlarge"
  allocated_storage     = 200
  max_allocated_storage = 1000
  database_name         = "proddb"
  master_username       = "admin"
  master_password       = var.db_password
  multi_az              = true
  deletion_protection   = true
  create_replica        = true
  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
}
