
#!/bin/bash
set -e

echo "=== Project Bedrock Deployment Script ==="

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "AWS Account ID: $ACCOUNT_ID"

echo "Updating kubeconfig..."
aws eks update-kubeconfig \
  --region us-east-1 \
  --name project-bedrock-cluster

echo "Getting Terraform outputs..."
cd terraform
ALB_ROLE_ARN=$(terraform output -raw alb_controller_role_arn 2>/dev/null || echo "")
CARTS_ROLE_ARN=$(terraform output -raw carts_dynamodb_role_arn 2>/dev/null || echo "")
MYSQL_HOST=$(terraform output -raw mysql_host 2>/dev/null || echo "")
POSTGRES_HOST=$(terraform output -raw postgres_host 2>/dev/null || echo "")
cd ..

echo "Updating aws-auth configmap with account ID..."
sed -i "s/ACCOUNT_ID/$ACCOUNT_ID/g" kubernetes/retail-app/aws-auth.yaml

echo "Updating ALB controller service account..."
sed -i "s|ALB_CONTROLLER_ROLE_ARN|$ALB_ROLE_ARN|g" kubernetes/retail-app/alb-controller-serviceaccount.yaml

echo "Applying namespace..."
kubectl apply -f kubernetes/retail-app/namespace.yaml

echo "Applying RBAC..."
kubectl apply -f kubernetes/retail-app/rbac.yaml

echo "Installing AWS Load Balancer Controller..."
helm repo add eks https://aws.github.io/eks-charts
helm repo update
kubectl apply -f kubernetes/retail-app/alb-controller-serviceaccount.yaml
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=project-bedrock-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

echo "Installing retail store app..."
helm repo add retail-store https://aws-containers.github.io/retail-store-sample-app
helm repo update
helm upgrade --install retail-store retail-store/retail-store-sample-app \
  -n retail-app \
  --create-namespace \
  --set catalog.db.endpoint=$POSTGRES_HOST \
  --set catalog.db.name=retaildb \
  --set catalog.db.user=postgres \
  --set catalog.db.passwordSecret=catalog-db-secret \
  --set orders.db.endpoint=$MYSQL_HOST \
  --set orders.db.name=orders \
  --set orders.db.user=dbadmin \
  --set orders.db.passwordSecret=orders-db-secret \
  --set carts.dynamodb.tableName=project-bedrock-carts \
  --set carts.serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=$CARTS_ROLE_ARN

echo "Applying ingress..."
kubectl apply -f kubernetes/retail-app/ingress.yaml

echo "=== Deployment complete ==="
kubectl get all -n retail-app


