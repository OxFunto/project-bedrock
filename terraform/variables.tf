variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "project-bedrock"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "node_desired_size" {
  default = 2
}

variable "node_min_size" {
  default = 2
}

variable "node_max_size" {
  default = 4
}

variable "mysql_password" {
  sensitive = true
}

variable "postgres_password" {
  sensitive = true
}
