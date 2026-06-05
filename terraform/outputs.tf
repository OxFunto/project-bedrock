output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.aws_region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "assets_bucket_name" {
  value = "bedrock-assets-alt-soe-025-4736"
}

output "alb_controller_role_arn" {
  value = module.iam.alb_controller_role_arn
}

output "carts_dynamodb_role_arn" {
  value = module.iam.carts_dynamodb_role_arn
}

output "mysql_host" {
  value = module.rds.mysql_host
}

output "postgres_host" {
  value = module.rds.postgres_host
}

output "dev_access_key_id" {
  value = module.iam.dev_access_key_id
}

output "dev_secret_access_key" {
  value     = module.iam.dev_secret_access_key
  sensitive = true
}

output "dev_console_password" {
  value     = module.iam.dev_console_password
  sensitive = true
}

output "alb_url" {
  value = "http://k8s-retailap-retailst-17d19cf248-117834514.us-east-1.elb.amazonaws.com"
}
