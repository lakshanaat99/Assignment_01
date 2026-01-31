# AWS ECS Fargate Deployment with Terraform and GitHub Actions

This project demonstrates a complete CI/CD pipeline for deploying a containerized Node.js application to AWS ECS Fargate using Terraform for infrastructure as code and GitHub Actions for continuous deployment.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [CI/CD Pipeline](#cicd-pipeline)
- [Testing the Application](#testing-the-application)
- [Infrastructure Components](#infrastructure-components)
- [Security Best Practices](#security-best-practices)

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        GitHub Actions                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  1. Build Docker Image                                │  │
│  │  2. Push to Amazon ECR                                │  │
│  │  3. Update ECS Task Definition                        │  │
│  │  4. Deploy to ECS Fargate Service                     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│                                                              │
│  ┌──────────────┐      ┌──────────────┐                    │
│  │  Public      │      │  Private     │                    │
│  │  Subnets      │      │  Subnets     │                    │
│  │              │      │              │                    │
│  │  ┌────────┐  │      │  ┌────────┐  │                    │
│  │  │  ALB   │──┼──────┼──│  ECS   │  │                    │
│  │  │        │  │      │  │ Tasks  │  │                    │
│  │  └────────┘  │      │  └────────┘  │                    │
│  │              │      │              │                    │
│  │  ┌────────┐  │      │              │                    │
│  │  │  NAT   │  │      │              │                    │
│  │  │ Gateway│  │      │              │                    │
│  │  └────────┘  │      │              │                    │
│  └──────────────┘      └──────────────┘                    │
│         │                      │                             │
│         └──────────┬──────────┘                             │
│                    │                                        │
│              ┌─────▼─────┐                                 │
│              │    VPC     │                                 │
│              └────────────┘                                 │
│                                                              │
│  ┌──────────────────────────────────────────────┐          │
│  │           Amazon ECR Repository               │          │
│  │  (Container Image Storage)                    │          │
│  └──────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### Architecture Components

1. **VPC with Public and Private Subnets**
   - Public subnets host the Application Load Balancer and NAT Gateways
   - Private subnets host ECS Fargate tasks for security
   - Multi-AZ deployment for high availability

2. **Application Load Balancer (ALB)**
   - Distributes traffic across ECS tasks
   - Health checks on `/health` endpoint
   - Accessible on port 80

3. **ECS Fargate Cluster**
   - Serverless container platform
   - Auto-scaling capabilities
   - Task definitions with health checks

4. **Amazon ECR**
   - Private Docker registry
   - Image scanning enabled
   - Lifecycle policies for cost optimization

5. **IAM Roles and Policies**
   - Task execution role for ECS
   - Task role for application permissions
   - GitHub Actions role with OIDC authentication

6. **CloudWatch Logs**
   - Centralized logging for ECS tasks
   - Log retention configured

## Features

- **Infrastructure as Code**: Complete infrastructure defined in Terraform
- **Automated CI/CD**: GitHub Actions pipeline for automated deployments
- **Secure Authentication**: OIDC-based authentication (no AWS credentials in code)
- **High Availability**: Multi-AZ deployment with load balancing
- **Health Checks**: Application and ALB health checks configured
- **Cost Optimization**: ECR lifecycle policies and efficient resource allocation
- **Security Best Practices**: Private subnets, security groups, least privilege IAM
- **Production Ready**: Logging, monitoring, and error handling

## Project Structure

```
.
├── app/
│   ├── server.js          # Node.js application
│   ├── package.json       # Node.js dependencies
│   ├── Dockerfile         # Container definition
│   └── .dockerignore      # Docker ignore file
├── terraform/
│   ├── main.tf            # Main Terraform configuration
│   ├── variables.tf       # Variable definitions
│   ├── vpc.tf             # VPC and networking
│   ├── ecr.tf              # ECR repository
│   ├── ecs.tf              # ECS cluster and service
│   ├── iam.tf              # IAM roles and policies
│   ├── security_groups.tf  # Security groups
│   ├── alb.tf              # Application Load Balancer
│   └── outputs.tf          # Output values
├── .github/
│   └── workflows/
│       └── deploy.yml      # GitHub Actions workflow
├── .gitignore             # Git ignore rules
└── README.md              # This file
```
## CI/CD Pipeline

The CI/CD pipeline is triggered on every push to the `main` branch:

### Pipeline Steps

1. **Checkout Code**: Retrieves the latest code from the repository
2. **Configure AWS Credentials**: Uses OIDC to authenticate with AWS
3. **Login to ECR**: Authenticates Docker with Amazon ECR
4. **Build Docker Image**: Builds the container image
5. **Tag and Push**: Tags image with commit SHA and `latest`, pushes to ECR
6. **Download Task Definition**: Retrieves current ECS task definition
7. **Update Task Definition**: Updates image reference in task definition
8. **Deploy to ECS**: Deploys new task definition and waits for service stability

### Workflow Features

- Automatic deployment on push to main
- Manual trigger option (`workflow_dispatch`)
- OIDC authentication (no AWS keys in secrets)
- Service stability wait (ensures deployment success)
- Deployment summary in GitHub Actions

## Testing the Application

### Health Check Endpoint

```bash
# Using curl
curl http://<ALB_DNS_NAME>/health

# Expected response:
{
  "status": "healthy",
  "timestamp": "2024-01-XX...",
  "uptime": 123.45,
  "environment": "prod"
}
```

### Access the Application

1. **Via Browser**: Navigate to `http://<ALB_DNS_NAME>`
2. **Via curl**:
   ```bash
   curl http://<ALB_DNS_NAME>/
   ```

### Local Testing

```bash
# Build and run locally
cd app
npm install
npm start

# Test in another terminal
curl http://localhost:8080/health
```

## Infrastructure Components

### VPC Configuration

- **CIDR**: 10.0.0.0/16
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24 (2 AZs)
- **Private Subnets**: 10.0.10.0/24, 10.0.11.0/24 (2 AZs)
- **NAT Gateways**: One per AZ for private subnet internet access

### ECS Configuration

- **Launch Type**: Fargate (serverless)
- **CPU**: 512 units (0.5 vCPU)
- **Memory**: 1024 MB (1 GB)
- **Desired Count**: 2 tasks (configurable)
- **Health Check**: HTTP check on `/health` endpoint

### ALB Configuration

- **Type**: Application Load Balancer
- **Port**: 80 (HTTP)
- **Health Check Path**: `/health`
- **Target Group**: Routes to ECS tasks on port 8080

### Security Groups

- **ALB SG**: Allows HTTP (80) and HTTPS (443) from internet
- **ECS SG**: Allows traffic from ALB on port 8080

## Security Best Practices

1. **No AWS Credentials in Code**
   - Uses OIDC for GitHub Actions authentication
   - No access keys or secrets committed

2. **Private Subnets for ECS**
   - ECS tasks run in private subnets
   - No direct internet access

3. **Least Privilege IAM**
   - Separate roles for task execution and task runtime
   - GitHub Actions role with minimal required permissions

4. **Security Groups**
   - Only necessary ports open

This project is created for the Cloud Infrastructure Design assignment.

## Author

[A.A.T.Lakshan]

---
