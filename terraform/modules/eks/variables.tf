variable "project_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "node_instance_type" {}
variable "node_desired_size" {}
variable "node_min_size" {}
variable "node_max_size" {}
