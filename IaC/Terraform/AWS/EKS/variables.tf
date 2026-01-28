variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "production"
}

variable "kubernetes_version" {
  default = "1.28"
}

variable "instance_types" {
  default = ["t3.medium"]
}

variable "desired_size" {
  default = 3
}

variable "max_size" {
  default = 10
}

variable "min_size" {
  default = 2
}

variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
