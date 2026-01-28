variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "production"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 6
}

variable "desired_capacity" {
  default = 3
}

variable "docker_image" {
  default = "deverathore13/nginx:latest"
}

variable "vpc_id" {}
variable "private_subnet_ids" {}
variable "public_subnet_ids" {}
