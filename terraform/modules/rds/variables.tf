variable "project_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "rds_security_group_id" {}
variable "mysql_password" { sensitive = true }
variable "postgres_password" { sensitive = true }
