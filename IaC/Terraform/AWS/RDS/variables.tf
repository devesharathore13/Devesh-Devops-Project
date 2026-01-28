variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "production"
}

variable "instance_class" {
  default = "db.t3.medium"
}

variable "allocated_storage" {
  default = 100
}

variable "max_allocated_storage" {
  default = 500
}

variable "database_name" {
  default = "appdb"
}

variable "master_username" {
  default = "admin"
}

variable "master_password" {
  sensitive = true
}

variable "multi_az" {
  default = true
}

variable "deletion_protection" {
  default = true
}

variable "create_replica" {
  default = false
}

variable "vpc_id" {}
variable "private_subnet_ids" {}
