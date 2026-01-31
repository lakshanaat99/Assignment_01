# Deployment Guide

This guide provides step-by-step instructions for deploying the application to AWS ECS Fargate.

## Prerequisites Checklist

- [ ] AWS Account with appropriate permissions
- [ ] Terraform >= 1.0 installed
- [ ] AWS CLI configured (`aws configure`)
- [ ] GitHub repository created
- [ ] Docker installed (for local testing)

## Step-by-Step Deployment

### 1. Clone and Setup

```bash
# Clone your repository
git clone <your-repo-url>
cd <repo-directory>

# Install Node.js dependencies (for local testing)
cd app
npm install
cd ..
```

### 2. Configure Terraform Variables

```bash
cd terraform

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Update at minimum:
# - aws_region
# - github_repo (format: username/repo-name)
```

### 3. Initialize Terraform

```bash
cd terraform
terraform init
```

This will download the required providers and modules.

### 4. Review Terraform Plan

```bash
terraform plan
```

Review the resources that will be created. You should see:
- VPC and networking components
- ECR repository
- ECS cluster and service
- IAM roles
- Application Load Balancer (if enabled)
- Security groups

### 5. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted. This will take approximately 5-10 minutes.

**Important Outputs to Save:**
- `ecr_repository_url` - You'll need this for Docker
- `alb_url` - Application URL (if ALB enabled)
- `github_actions_role_arn` - For GitHub Actions setup

### 6. Build and Push Initial Docker Image

```bash
# Get ECR login command
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <ecr-repository-url>

# Build the image
cd ../app
docker build -t <app-name> .

# Tag the image
docker tag <app-name>:latest <ecr-repository-url>:latest

# Push to ECR
docker push <ecr-repository-url>:latest
```

### 7. Configure GitHub Actions

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add secret:
   - **Name**: `AWS_ROLE_ARN`
   - **Value**: Copy from Terraform output `github_actions_role_arn`

### 8. Update GitHub Actions Workflow

Edit `.github/workflows/deploy.yml` and update these values if needed:
- `ECR_REPOSITORY`: Should match your `app_name`
- `ECS_CLUSTER`: Should match `${app_name}-cluster`
- `ECS_SERVICE`: Should match `${app_name}-service`
- `ECS_TASK_DEFINITION`: Should match your `app_name`

### 9. Push to GitHub

```bash
# Add all files
git add .

# Commit
git commit -m "Initial deployment setup"

# Push to main branch (this will trigger the workflow)
git push origin main
```

### 10. Monitor Deployment

1. Go to GitHub → **Actions** tab
2. Watch the workflow run
3. Wait for "Deploy Amazon ECS task definition" step to complete
4. The workflow will wait for service stability

### 11. Verify Deployment

```bash
# Get ALB URL from Terraform outputs
terraform output alb_url

# Test health endpoint
curl http://<alb-dns-name>/health

# Test main page
curl http://<alb-dns-name>/
```

Or open the ALB URL in your browser.

## Troubleshooting

### Issue: Terraform Apply Fails

**Common Causes:**
- Insufficient AWS permissions
- Region not available
- Resource limits exceeded

**Solution:**
- Check AWS credentials: `aws sts get-caller-identity`
- Verify region availability
- Check service quotas in AWS Console

### Issue: ECS Tasks Not Starting

**Check:**
```bash
# View service events
aws ecs describe-services \
  --cluster <cluster-name> \
  --services <service-name>

# Check CloudWatch logs
aws logs tail /ecs/<app-name> --follow
```

**Common Issues:**
- Task definition image not found (push image to ECR first)
- Security group misconfiguration
- Insufficient CPU/memory

### Issue: GitHub Actions Fails

**Check:**
- `AWS_ROLE_ARN` secret is set correctly
- OIDC provider is configured (should be automatic)
- IAM role trust policy includes your repo

**Verify OIDC:**
```bash
aws iam list-open-id-connect-providers
```

### Issue: Application Not Accessible

**Check:**
1. ALB target group health
2. Security group rules
3. ECS tasks are running
4. Network ACLs (should be default)

## Post-Deployment

### Update Application

1. Make changes to `app/server.js`
2. Commit and push to `main` branch
3. GitHub Actions will automatically:
   - Build new Docker image
   - Push to ECR
   - Deploy to ECS

### Scale Application

```bash
# Update desired count
terraform apply -var="desired_count=4"
```

Or use ECS Auto Scaling (configure separately).

### View Logs

```bash
# CloudWatch Logs
aws logs tail /ecs/<app-name> --follow

# Or via AWS Console
# CloudWatch → Log Groups → /ecs/<app-name>
```

### Clean Up (Destroy Infrastructure)

```bash
cd terraform
terraform destroy
```

**Warning:** This will delete all resources. Make sure you want to do this!

## Next Steps

- [ ] Set up custom domain with Route 53
- [ ] Configure HTTPS with ACM certificate
- [ ] Set up CloudWatch alarms
- [ ] Configure auto-scaling
- [ ] Add monitoring dashboard
- [ ] Set up backup strategy

## Support

For issues or questions:
1. Check CloudWatch logs
2. Review GitHub Actions logs
3. Check AWS service health
4. Review Terraform state: `terraform show`
