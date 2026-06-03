#!/bin/bash
set -e

echo "=== Project Bedrock Cleanup ==="

echo "Deleting Kubernetes resources..."
kubectl delete namespace retail-app --ignore-not-found
helm uninstall aws-load-balancer-controller -n kube-system --ignore-not-found

echo "Destroying Terraform infrastructure..."
cd terraform
terraform destroy -auto-approve

echo "=== Cleanup complete ==="
