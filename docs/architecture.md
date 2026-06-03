Internet
│
▼
┌─────────────────────────────────────────────────────────┐
│                    AWS Cloud (us-east-1)                 │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │              project-bedrock-vpc                  │   │
│  │           CIDR: 10.0.0.0/16                      │   │
│  │                                                   │   │
│  │  ┌─────────────┐      ┌─────────────┐           │   │
│  │  │  Public AZ1  │      │  Public AZ2  │           │   │
│  │  │ 10.0.0.0/24  │      │ 10.0.1.0/24  │           │   │
│  │  │              │      │              │           │   │
│  │  │  NAT Gateway │      │              │           │   │
│  │  │  ALB         │      │  ALB         │           │   │
│  │  └──────┬───────┘      └──────┬───────┘           │   │
│  │         │                     │                   │   │
│  │  ┌──────▼───────┐      ┌──────▼───────┐           │   │
│  │  │  Private AZ1 │      │  Private AZ2 │           │   │
│  │  │ 10.0.10.0/24 │      │ 10.0.11.0/24 │           │   │
│  │  │              │      │              │           │   │
│  │  │  EKS Nodes   │      │  EKS Nodes   │           │   │
│  │  │  RDS MySQL   │      │  RDS Postgres│           │   │
│  │  └──────────────┘      └──────────────┘           │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌───────────────────┐    ┌──────────────────────────┐  │
│  │   EKS Cluster     │    │    Managed Services       │  │
│  │                   │    │                           │  │
│  │  retail-app ns:   │    │  RDS MySQL (orders)       │  │
│  │  - ui             │    │  RDS Postgres (catalog)   │  │
│  │  - catalog        │    │  DynamoDB (carts)         │  │
│  │  - orders         │    │  S3 (assets)              │  │
│  │  - carts          │    │  Lambda (processor)       │  │
│  │  - checkout       │    │  CloudWatch (logs)        │  │
│  │  - assets         │    │                           │  │
│  └───────────────────┘    └──────────────────────────┘  │
└─────────────────────────────────────────────────────────┘

--> S3 to Lambda Flow
Developer/Grader
│
│  s3:PutObject
▼
┌─────────────────────┐
│  S3 Bucket          │
│  bedrock-assets-    │
│  alt-soe-025-4736   │
└──────────┬──────────┘
│  S3 Event Notification
│  (s3:ObjectCreated:*)
▼
┌─────────────────────┐
│  Lambda Function    │
│  bedrock-asset-     │
│  processor          │
│                     │
│  Logs:              │
│  "Image received:   │
│   [filename]"       │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│  CloudWatch Logs    │
│  /aws/lambda/       │
│  bedrock-asset-     │
│  processor          │
└─────────────────────┘

--> Data Layer

| Service | AWS Resource | Purpose |
|---------|-------------|---------|
| Catalog | RDS PostgreSQL | Product catalog data |
| Orders | RDS MySQL | Order management |
| Carts | DynamoDB | Shopping cart sessions |
| Assets | S3 | Product images |

--> Security

- RDS instances in private subnets only
- Security groups restrict DB access to VPC CIDR only
- Database credentials stored in Kubernetes secrets
- IRSA for pod-level AWS access (DynamoDB, ALB Controller)
- Developer user has read-only access only
- S3 bucket is private with explicit deny on public access
