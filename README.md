# AWS ECS Fargate Deployment with Terraform and GitHub Actions

This project demonstrates a complete CI/CD pipeline for deploying a containerized Node.js application to AWS ECS Fargate using Terraform for infrastructure as code and GitHub Actions for continuous deployment.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [CI/CD Pipeline](#cicd-pipeline)
- [Testing the Application](#testing-the-application)
- [Infrastructure Components](#infrastructure-components)
- [Security Best Practices](#security-best-practices)

## Architecture Overview

The infrastructure is built around a secure Virtual Private Cloud (VPC) environment, segmented into public and private layers to ensure a high level of security.

1. Network & Traffic Management
Public and Private Subnets: To safeguard the application, all core logic (ECS Tasks) resides in Private Subnets. These are not directly accessible from the internet. The Public Subnets house the entry points, specifically the Load Balancer and NAT Gateways.

Application Load Balancer (ALB): This serves as the single point of contact for clients. It routes incoming traffic on port 80 to the healthy container instances in the background, ensuring smooth traffic distribution.

NAT Gateway: This allows the private containers to securely access the internet for updates or external API calls without exposing them to inbound threats.

2. Compute & Container Orchestration
AWS Fargate (ECS): We utilize a serverless compute engine for our containers. By using Fargate, we don't have to manage underlying servers; we simply define the resources (CPU/Memory) needed, and AWS handles the scaling and maintenance.

Amazon ECR: This acts as our private repository. Every time a new version of the application is built, it is stored here as a Docker image.

Deployment Pipeline (CI/CD)
The deployment process is fully automated using GitHub Actions, following a streamlined four-step workflow:

Build: A Docker image is created from the latest source code.

Registry: The image is pushed to Amazon ECR, where it is scanned for security vulnerabilities.

Definition: The ECS Task Definition is updated to point to the new image version.

Rollout: ECS performs a "rolling update," replacing old containers with new ones only after they pass health checks.

Core Security & Reliability Features
Identity & Access Management (IAM): The system uses the principle of least privilege. GitHub Actions connects to AWS via OIDC, meaning no permanent AWS keys are stored in the repository, significantly reducing the risk of credential leaks.

High Availability: The architecture is deployed across multiple Availability Zones (Multi-AZ). If one AWS data center experiences an issue, the application remains online via the others.

Monitoring & Observability: All application logs are centralized in Amazon CloudWatch, allowing for real-time monitoring of system health and performance.

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

### Testing the Application 
Once the infrastructure is provisioned and the containers are deployed, we use the following methods to ensure the environment is stable and the application is reachable.

1. Retrieving the Entry Point
The application is accessed through the Application Load Balancer (ALB). Since Terraform manages the infrastructure, we extract the generated DNS name directly from the state file.

From the terraform directory, run:

```
terraform output alb_dns_name
This provides the public URL used for all subsequent production tests.
```
2. Connectivity & Health Verification
The primary test is to verify that the ALB can successfully route traffic to the ECS tasks in the private subnet. We target the /health endpoint, which confirms that the container is not only running but internally functional.

Command:

```
curl http://localhost:8080/health
Success Criteria: A successful connection returns a JSON object confirming a healthy status.
This validates that the security groups, target groups, and NAT Gateways are all configured correctly to allow traffic flow.
```
3. Local Development Environment
To speed up the development cycle, the application was tested locally before being pushed to AWS, ensures the code is functional before initiating the CI/CD pipeline.

Commands:
```
Initialization: Navigate to the app folder and run npm install to load dependencies.

Execution: Run npm start to host the app on the local machine.

Verification: Access http://localhost:8080/health to mirror the production health check.
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
