-> Project Bedrock - InnovateMart EKS Deployment
Production-grade microservices on AWS EKS for InnovateMart Inc.

--> Architecture Overview

- **VPC:** Custom VPC (project-bedrock-vpc) with public and private subnets across 2 AZs
- **EKS:** Managed Kubernetes cluster (project-bedrock-cluster) v1.31
- **Data Layer:** RDS MySQL, RDS PostgreSQL, DynamoDB
- **Ingress:** AWS Load Balancer Controller with ALB
- **Observability:** CloudWatch Container Insights via EKS Add-on
- **Serverless:** S3 bucket + Lambda trigger for asset processing
- **CI/CD:** GitHub Actions for Terraform plan on PR and apply on merge

-->  Repository Structure
project-bedrock/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/
│       ├── eks/
│       ├── rds/
│       ├── dynamodb/
│       ├── iam/
│       ├── security-groups/
│       └── s3-lambda/
├── kubernetes/
│   └── retail-app/
│       ├── namespace.yaml
│       ├── rbac.yaml
│       ├── aws-auth.yaml
│       ├── ingress.yaml
│       └── alb-controller-serviceaccount.yaml
├── lambda/
│   └── lambda_function.py
├── scripts/
│   └── deploy.sh
└── docs/
└── architecture.md

-->  Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- kubectl
- helm
- eksctl

-->  Deployment Guide

--> Step 1 - Set up remote state bucket

This only needs to be done once:

```bash
aws s3 mb s3://project-bedrock-tfstate-alt-soe-025-4736 --region us-east-1
aws s3api put-bucket-versioning \
  --bucket project-bedrock-tfstate-alt-soe-025-4736 \
  --versioning-configuration Status=Enabled
```

--> Step 2 - Configure variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

Fill in your database passwords.

--> Step 3 - Deploy infrastructure

```bash
terraform init
terraform plan
terraform apply
```

This will take approximately 25-35 minutes. Resources created:
- VPC with subnets, NAT Gateway, route tables
- EKS cluster and managed node group
- RDS MySQL and PostgreSQL instances
- DynamoDB table
- S3 bucket and Lambda function
- IAM roles and policies

--> Step 4 - Deploy the application

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

--> Step 5 - Get the application URL

```bash
kubectl get ingress -n retail-app
```

Copy the ADDRESS field and open it in your browser.

--> Step 6 - Generate grading file

```bash
cd terraform
terraform output -json > ../grading.json
```

--> CI/CD Pipeline

--> How it works

- **Pull Request to main:** Triggers `terraform plan`. The plan output is posted as a PR comment automatically.
- **Merge to main:** Triggers `terraform apply` which deploys infrastructure changes.

--> Required GitHub Secrets

Go to your repo Settings → Secrets and variables → Actions and add:

| Secret | Description |
|--------|-------------|
| AWS_ACCESS_KEY_ID | Your AWS access key |
| AWS_SECRET_ACCESS_KEY | Your AWS secret key |
| MYSQL_PASSWORD | RDS MySQL password |
| POSTGRES_PASSWORD | RDS PostgreSQL password |

--> Developer Access

The `bedrock-dev-view` IAM user has:
- AWS Console read-only access via `ReadOnlyAccess` policy
- S3 PutObject on the assets bucket
- Kubernetes view access via ClusterRoleBinding

To verify Kubernetes access:
```bash
# This should work
kubectl get pods -n retail-app

--> This should fail
kubectl delete pod <pod-name> -n retail-app
```

--> Tearing Down

To destroy all resources and stop AWS charges:

```bash
cd terraform
terraform destroy -auto-approve
```

This takes approximately 15-20 minutes.

--> Resource Naming Conventions

| Resource | Name |
|----------|------|
| EKS Cluster | project-bedrock-cluster |
| VPC | project-bedrock-vpc |
| S3 Assets Bucket | bedrock-assets-alt-soe-025-4736 |
| Lambda Function | bedrock-asset-processor |
| IAM Dev User | bedrock-dev-view |
| App Namespace | retail-app |
| Project Tag | karatu-2026-capstone |

--> Helm Deployment

The application can be deployed with a single command:

```bash
helm upgrade --install retail-store ./helm/retail-store \
  --namespace retail-app \
  --create-namespace \
  --set mysql.host=project-bedrock-mysql.c6744gw0eixf.us-east-1.rds.amazonaws.com \
  --set postgres.host=project-bedrock-postgres.c6744gw0eixf.us-east-1.rds.amazonaws.com \
  --set dynamodb.tableName=project-bedrock-carts \
  --set carts.serviceAccount.roleArn=arn:aws:iam::887930139017:role/project-bedrock-carts-dynamodb-role
```

To apply the full application manifests:
```bash
kubectl apply -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml -n retail-app
```
# Pipeline test Sat Jun  6 18:58:51 WAT 2026
