# Quick Start Guide

Get your application deployed in 15 minutes!

## Prerequisites

- AWS Account
- Terraform installed
- AWS CLI configured
- GitHub repository

## Quick Steps

### 1. Configure Variables (2 minutes)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 2. Deploy Infrastructure (5 minutes)

```bash
terraform init
terraform apply
# Save the outputs, especially github_actions_role_arn
```

### 3. Add Your Name to App (1 minute)

Edit `app/server.js`:
```javascript
const STUDENT_NAME = "Your Actual Name";
```

### 4. Push Initial Image (2 minutes)

```bash
# Get ECR login
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <ecr-url>

# Build and push
cd app
docker build -t fargate-app .
docker tag fargate-app:latest <ecr-url>:latest
docker push <ecr-url>:latest
```

### 5. Configure GitHub (2 minutes)

1. GitHub Repo → Settings → Secrets → Actions
2. Add secret: `AWS_ROLE_ARN` = value from terraform output

### 6. Push to GitHub (1 minute)

```bash
git add .
git commit -m "Initial deployment"
git push origin main
```

### 7. Wait and Verify (2 minutes)

- Watch GitHub Actions workflow
- Get ALB URL from terraform outputs
- Test: `curl http://<alb-url>/health`

## That's It! 🎉

Your application is now live and will auto-deploy on every push to main.

## Need Help?

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed instructions.
