# Setup Checklist - What to Do Next

## ✅ Current Status

- ✅ Code pushed to GitHub: https://github.com/lakshanaat99/Assignment_01
- ✅ Repository structure complete
- ⚠️ Need to install tools (AWS CLI, Terraform)
- ⚠️ Need to update configuration files
- ⚠️ Need to deploy infrastructure

## 🔧 Step 1: Install Required Tools

### Install AWS CLI

**Option A: Using MSI Installer (Recommended for Windows)**
1. Download: https://awscli.amazonaws.com/AWSCLIV2.msi
2. Run the installer
3. Verify: Open new PowerShell and run `aws --version`

**Option B: Using Chocolatey**
```powershell
choco install awscli
```

### Install Terraform

**Option A: Using Chocolatey**
```powershell
choco install terraform
```

**Option B: Manual Installation**
1. Download: https://developer.hashicorp.com/terraform/downloads
2. Extract and add to PATH
3. Verify: `terraform version`

### Install Docker (for local testing)

**Option A: Docker Desktop**
1. Download: https://www.docker.com/products/docker-desktop/
2. Install and start Docker Desktop
3. Verify: `docker --version`

**Option B: Using Chocolatey**
```powershell
choco install docker-desktop
```

## 📝 Step 2: Update Configuration Files

### 2.1 Update Your Name

Edit `app/server.js`:
```javascript
const STUDENT_NAME = "Your Actual Name";
```

### 2.2 Update Terraform Variables

Edit `terraform/terraform.tfvars`:
```hcl
aws_region    = "us-east-1"  # Change if needed
environment   = "prod"
app_name      = "fargate-app"
github_repo    = "lakshanaat99/Assignment_01"  # ✅ Update this!
github_branch  = "main"
enable_alb     = true
desired_count  = 2
container_cpu  = 512
container_memory = 1024
app_port       = 8080
```

**Important**: Update `github_repo` to `lakshanaat99/Assignment_01`

## 🔐 Step 3: Configure AWS

### 3.1 Configure AWS CLI

```powershell
aws configure
```

You'll need:
- **AWS Access Key ID**: From AWS Console → IAM → Users → Security credentials
- **AWS Secret Access Key**: Same location
- **Default region**: `us-east-1` (or your preferred region)
- **Default output format**: `json`

### 3.2 Verify AWS Access

```powershell
aws sts get-caller-identity
```

This should show your AWS account details.

## 🚀 Step 4: Deploy Infrastructure

### 4.1 Initialize Terraform

```powershell
cd terraform
terraform init
```

This downloads required providers and modules.

### 4.2 Review Deployment Plan

```powershell
terraform plan
```

Review what will be created. You should see:
- VPC and networking
- ECR repository
- ECS cluster
- IAM roles
- Application Load Balancer
- Security groups

### 4.3 Deploy Infrastructure

```powershell
terraform apply
```

Type `yes` when prompted. This takes ~10-15 minutes.

**⚠️ IMPORTANT**: Save these outputs:
- `github_actions_role_arn` - For GitHub Actions secret
- `alb_url` - Your application URL
- `ecr_repository_url` - For Docker push

## 🐳 Step 5: Push Initial Docker Image

Before GitHub Actions can deploy, push an initial image:

```powershell
# Get ECR login (replace with your region and ECR URL from terraform output)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ecr-repository-url>

# Build the image
cd ..\app
docker build -t fargate-app .

# Tag the image
docker tag fargate-app:latest <ecr-repository-url>:latest

# Push to ECR
docker push <ecr-repository-url>:latest
```

## 🔑 Step 6: Configure GitHub Actions Secret

1. Go to: https://github.com/lakshanaat99/Assignment_01/settings/secrets/actions
2. Click **"New repository secret"**
3. **Name**: `AWS_ROLE_ARN`
4. **Value**: Copy from terraform output `github_actions_role_arn`
5. Click **"Add secret"**

## 🎯 Step 7: Trigger CI/CD Pipeline

Make a small change and push:

```powershell
# Update your name if not done
# Edit app/server.js

# Commit and push
git add .
git commit -m "Update student name and trigger deployment"
git push origin main
```

Watch the deployment:
- Go to: https://github.com/lakshanaat99/Assignment_01/actions

## ✅ Step 8: Test Your Application

Once deployed:

```powershell
# Get ALB URL
cd terraform
terraform output alb_url

# Test health endpoint
curl http://<alb-dns-name>/health

# Or open in browser
# http://<alb-dns-name>/
```

## 📸 Step 9: Take Screenshots for Submission

1. **GitHub Actions**: Successful workflow run
2. **ECS Console**: Service with running tasks
3. **ECR Console**: Repository with images
4. **Browser**: Application showing your name
5. **Health Check**: `/health` endpoint response

## 🆘 Troubleshooting

### AWS CLI not found
- Restart PowerShell after installation
- Check PATH environment variable

### Terraform not found
- Restart PowerShell after installation
- Verify installation: `terraform version`

### Docker not found
- Start Docker Desktop
- Wait for it to fully start

### Terraform apply fails
- Check AWS credentials: `aws sts get-caller-identity`
- Verify region is available
- Check service quotas in AWS Console

## 📚 Quick Reference

- **Repository**: https://github.com/lakshanaat99/Assignment_01
- **Detailed Guide**: See `DEPLOYMENT_GUIDE.md`
- **Quick Start**: See `QUICK_START.md`
- **Checklist**: See `ASSIGNMENT_CHECKLIST.md`

## 🎯 Priority Order

1. **Install tools** (AWS CLI, Terraform, Docker)
2. **Configure AWS** (`aws configure`)
3. **Update files** (student name, terraform.tfvars)
4. **Deploy infrastructure** (`terraform apply`)
5. **Push initial image** (Docker)
6. **Configure GitHub secret** (AWS_ROLE_ARN)
7. **Trigger deployment** (push to GitHub)
8. **Test application** (verify it works)
9. **Take screenshots** (for submission)

---

**Start with installing the tools, then follow the steps in order!** 🚀
