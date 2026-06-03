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

output "alb_url" {
  value = "Check kubectl get ingress -n retail-app for ALB URL"
}
