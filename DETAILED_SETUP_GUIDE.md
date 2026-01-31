# Complete Step-by-Step Setup Guide

This is a comprehensive, detailed guide covering every single step needed to complete the assignment.

---

## 📋 Table of Contents

1. [Prerequisites Check](#1-prerequisites-check)
2. [Install Required Tools](#2-install-required-tools)
3. [AWS Account Setup](#3-aws-account-setup)
4. [Update Configuration Files](#4-update-configuration-files)
5. [Configure AWS CLI](#5-configure-aws-cli)
6. [Deploy Infrastructure with Terraform](#6-deploy-infrastructure-with-terraform)
7. [Push Initial Docker Image](#7-push-initial-docker-image)
8. [Configure GitHub Actions Secret](#8-configure-github-actions-secret)
9. [Test Local Application](#9-test-local-application)
10. [Trigger CI/CD Pipeline](#10-trigger-cicd-pipeline)
11. [Verify Deployment](#11-verify-deployment)
12. [Take Screenshots for Submission](#12-take-screenshots-for-submission)

---

## 1. Prerequisites Check

### 1.1 Check Current Setup

Open PowerShell and run these commands to check what's already installed:

```powershell
# Check if Git is installed
git --version

# Check if Node.js is installed (optional, for local testing)
node --version

# Check if Docker is installed
docker --version

# Check if AWS CLI is installed
aws --version

# Check if Terraform is installed
terraform version
```

**Expected Results:**
- Git: Should show version (e.g., `git version 2.x.x`)
- Node.js: Optional, but helpful for local testing
- Docker: Will show "not recognized" if not installed
- AWS CLI: Will show "not recognized" if not installed
- Terraform: Will show "not recognized" if not installed

**Note**: If any tool shows "not recognized", you need to install it in the next section.

---

## 2. Install Required Tools

### 2.1 Install AWS CLI

#### Method A: MSI Installer (Recommended for Windows)

**Step 1**: Download the installer
- Go to: https://awscli.amazonaws.com/AWSCLIV2.msi
- Click the download link
- Save the file (usually goes to Downloads folder)

**Step 2**: Run the installer
- Navigate to Downloads folder
- Double-click `AWSCLIV2.msi`
- Click "Next" on the welcome screen
- Accept the license agreement
- Click "Install"
- Wait for installation to complete
- Click "Finish"

**Step 3**: Verify installation
- Close current PowerShell window
- Open a NEW PowerShell window (important!)
- Run: `aws --version`
- Expected output: `aws-cli/2.x.x Python/3.x.x ...`

**Troubleshooting**:
- If still not recognized, restart your computer
- Or manually add to PATH (advanced)

#### Method B: Using Chocolatey (Alternative)

If you have Chocolatey installed:

```powershell
choco install awscli
```

Then restart PowerShell and verify: `aws --version`

---

### 2.2 Install Terraform

#### Method A: Using Chocolatey (Easiest)

**Step 1**: Check if Chocolatey is installed
```powershell
choco --version
```

If not installed, install Chocolatey first:
- Open PowerShell as Administrator
- Run: `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`
- Close and reopen PowerShell

**Step 2**: Install Terraform
```powershell
choco install terraform
```

**Step 3**: Verify installation
- Close and reopen PowerShell
- Run: `terraform version`
- Expected output: `Terraform v1.x.x`

#### Method B: Manual Installation

**Step 1**: Download Terraform
- Go to: https://developer.hashicorp.com/terraform/downloads
- Click "Windows" tab
- Download the zip file (e.g., `terraform_1.x.x_windows_amd64.zip`)

**Step 2**: Extract and install
- Extract the zip file
- Copy `terraform.exe` to a folder (e.g., `C:\terraform`)
- Add folder to PATH:
  - Right-click "This PC" → Properties
  - Advanced system settings → Environment Variables
  - Under "System variables", find "Path" → Edit
  - Click "New" → Add `C:\terraform` (or your folder)
  - Click OK on all dialogs

**Step 3**: Verify installation
- Close and reopen PowerShell
- Run: `terraform version`

---

### 2.3 Install Docker Desktop

**Step 1**: Download Docker Desktop
- Go to: https://www.docker.com/products/docker-desktop/
- Click "Download for Windows"
- Save the installer

**Step 2**: Run the installer
- Double-click the installer
- Follow the installation wizard
- Make sure "Use WSL 2 instead of Hyper-V" is checked (if available)
- Click "Install"
- Wait for installation to complete

**Step 3**: Start Docker Desktop
- Launch Docker Desktop from Start menu
- Wait for it to start (whale icon in system tray)
- You may need to accept license agreement

**Step 4**: Verify installation
- Open PowerShell
- Run: `docker --version`
- Expected output: `Docker version 24.x.x, build ...`
- Run: `docker ps` (should show empty list, not an error)

**Troubleshooting**:
- If Docker Desktop won't start, check Windows features:
  - Enable "Virtual Machine Platform" and "Windows Subsystem for Linux"
  - Restart computer

---

## 3. AWS Account Setup

### 3.1 Create AWS Account (If Needed)

If you don't have an AWS account:

**Step 1**: Go to AWS
- Visit: https://aws.amazon.com/
- Click "Create an AWS Account"

**Step 2**: Follow the signup process
- Enter email and account name
- Choose account type (Personal)
- Enter payment information (credit card required, but free tier available)
- Verify phone number
- Choose support plan (Basic is free)

**Step 3**: Wait for account activation
- Usually takes a few minutes
- Check email for confirmation

### 3.2 Create IAM User for Programmatic Access

**Step 1**: Sign in to AWS Console
- Go to: https://console.aws.amazon.com/
- Sign in with your root account

**Step 2**: Navigate to IAM
- Click "Services" (top left)
- Search for "IAM"
- Click "IAM"

**Step 3**: Create new user
- Click "Users" in left sidebar
- Click "Create user" button
- User name: `terraform-user` (or any name)
- Click "Next"

**Step 4**: Set permissions
- Select "Attach policies directly"
- Search for and select:
  - `AdministratorAccess` (for full access, or create custom policy)
- Click "Next"
- Click "Create user"

**Step 5**: Create access keys
- Click on the user you just created
- Click "Security credentials" tab
- Scroll to "Access keys" section
- Click "Create access key"
- Select "Command Line Interface (CLI)"
- Check the confirmation box
- Click "Next"
- Click "Create access key"

**Step 6**: Save credentials (IMPORTANT!)
- **Access Key ID**: Copy this value
- **Secret Access Key**: Click "Show" and copy this value
- **⚠️ WARNING**: Save these securely. You won't see the secret key again!
- Click "Done"

**Step 7**: Note your AWS Region
- In AWS Console, check the region in top right (e.g., "US East (N. Virginia)")
- Default region code: `us-east-1` (for N. Virginia)
- Other common regions:
  - `us-west-2` (Oregon)
  - `eu-west-1` (Ireland)
  - `ap-southeast-1` (Singapore)

---

## 4. Update Configuration Files

### 4.1 Update Student Name

**Step 1**: Open the file
- Navigate to: `E:\SLTC\CODES\CID_CA1\app\server.js`
- Open in your code editor

**Step 2**: Find the line
- Look for: `const STUDENT_NAME = "Your Name Here";`
- It should be around line 6

**Step 3**: Update with your name
- Change to: `const STUDENT_NAME = "Your Actual Name";`
- Replace "Your Actual Name" with your real name
- Example: `const STUDENT_NAME = "John Doe";`

**Step 4**: Save the file
- Press `Ctrl + S` to save

**Step 5**: Verify the change
- The file should show your name in the constant

---

### 4.2 Update Terraform Variables

**Step 1**: Open the file
- Navigate to: `E:\SLTC\CODES\CID_CA1\terraform\terraform.tfvars`
- Open in your code editor

**Step 2**: Review current values
The file should look like:
```hcl
aws_region    = "us-east-1"
environment   = "prod"
app_name      = "fargate-app"
github_repo    = "lakshanaat99/Assignment_01"
github_branch  = "main"
enable_alb     = true
desired_count  = 2
container_cpu  = 512
container_memory = 1024
app_port       = 8080
```

**Step 3**: Update if needed
- `aws_region`: Change if you want a different region (e.g., `us-west-2`)
- `github_repo`: Should already be `lakshanaat99/Assignment_01` ✅
- Other values can stay as default

**Step 4**: Save the file
- Press `Ctrl + S` to save

**Note**: This file is in `.gitignore`, so it won't be committed to GitHub (this is correct for security).

---

## 5. Configure AWS CLI

### 5.1 Run AWS Configure

**Step 1**: Open PowerShell
- Make sure it's a fresh window (restart if needed)

**Step 2**: Run configure command
```powershell
aws configure
```

**Step 3**: Enter AWS Access Key ID
- Prompt: `AWS Access Key ID [None]:`
- Paste your Access Key ID from step 3.2.6
- Press Enter

**Step 4**: Enter AWS Secret Access Key
- Prompt: `AWS Secret Access Key [None]:`
- Paste your Secret Access Key from step 3.2.6
- Press Enter

**Step 5**: Enter Default region
- Prompt: `Default region name [None]:`
- Enter: `us-east-1` (or your preferred region)
- Press Enter

**Step 6**: Enter Default output format
- Prompt: `Default output format [None]:`
- Enter: `json`
- Press Enter

**Expected Output**:
```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

### 5.2 Verify AWS Configuration

**Step 1**: Test AWS connection
```powershell
aws sts get-caller-identity
```

**Expected Output** (JSON format):
```json
{
    "UserId": "AIDA...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-user"
}
```

**Step 2**: If you see an error
- Check your credentials are correct
- Verify IAM user has permissions
- Check internet connection
- Try: `aws configure list` to see current config

**Step 3**: Test region access
```powershell
aws ec2 describe-regions --region-names us-east-1
```

Should return region information without errors.

---

## 6. Deploy Infrastructure with Terraform

### 6.1 Navigate to Terraform Directory

**Step 1**: Open PowerShell
- Make sure you're in the project directory

**Step 2**: Change to terraform directory
```powershell
cd E:\SLTC\CODES\CID_CA1\terraform
```

**Step 3**: Verify you're in the right place
```powershell
pwd
# Should show: E:\SLTC\CODES\CID_CA1\terraform

ls
# Should show: main.tf, variables.tf, vpc.tf, etc.
```

---

### 6.2 Initialize Terraform

**Step 1**: Run terraform init
```powershell
terraform init
```

**Step 2**: Wait for initialization
- Terraform will download providers and modules
- This may take 1-2 minutes
- You'll see output like:
```
Initializing modules...
Downloading terraform-aws-modules/ecs/aws 5.0.0...
Initializing the backend...
Initializing provider plugins...
```

**Step 3**: Verify success
- Should end with: `Terraform has been successfully initialized!`
- If you see errors:
  - Check internet connection
  - Verify terraform.tfvars exists
  - Check file permissions

**Step 4**: Check .terraform directory created
```powershell
ls .terraform
# Should show providers and modules directories
```

---

### 6.3 Review Terraform Plan

**Step 1**: Run terraform plan
```powershell
terraform plan
```

**Step 2**: Review the output
- Terraform will show what will be created
- Look for:
  - VPC resources
  - ECS cluster
  - ECR repository
  - IAM roles
  - Security groups
  - Application Load Balancer

**Step 3**: Check for errors
- If you see errors, read them carefully
- Common issues:
  - Missing variables
  - Invalid region
  - Permission issues

**Step 4**: Note the plan summary
- Should show: `Plan: X to add, 0 to change, 0 to destroy.`
- X will be around 30-40 resources

---

### 6.4 Apply Terraform Configuration

**Step 1**: Run terraform apply
```powershell
terraform apply
```

**Step 2**: Review the plan again
- Terraform will show the plan
- Review it carefully

**Step 3**: Confirm deployment
- Prompt: `Do you want to perform these actions?`
- Type: `yes`
- Press Enter

**Step 4**: Wait for deployment
- This will take 10-15 minutes
- Terraform will create resources one by one
- You'll see progress like:
  ```
  aws_vpc.main: Creating...
  aws_vpc.main: Creation complete after 3s
  aws_subnet.public[0]: Creating...
  ...
  ```

**Step 5**: Watch for completion
- Wait until you see: `Apply complete!`
- Note the outputs at the end

**Step 6**: Save the outputs (CRITICAL!)
Terraform will show outputs like:
```
Outputs:

ecr_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-app"
ecs_cluster_name = "fargate-app-cluster"
ecs_service_name = "fargate-app-service"
alb_dns_name = "fargate-app-alb-1234567890.us-east-1.elb.amazonaws.com"
alb_url = "http://fargate-app-alb-1234567890.us-east-1.elb.amazonaws.com"
github_actions_role_arn = "arn:aws:iam::123456789012:role/fargate-app-github-actions-role"
```

**⚠️ IMPORTANT**: Copy these values! Especially:
- `github_actions_role_arn` - You'll need this for GitHub
- `alb_url` - Your application URL
- `ecr_repository_url` - For Docker push

**Step 7**: Save outputs to a file (optional but recommended)
```powershell
terraform output > terraform-outputs.txt
```

---

### 6.5 Verify Infrastructure in AWS Console

**Step 1**: Check VPC
- Go to: https://console.aws.amazon.com/vpc/
- Click "Your VPCs"
- Should see: `fargate-app-vpc`

**Step 2**: Check ECS Cluster
- Go to: https://console.aws.amazon.com/ecs/
- Click "Clusters"
- Should see: `fargate-app-cluster`

**Step 3**: Check ECR Repository
- Go to: https://console.aws.amazon.com/ecr/
- Click "Repositories"
- Should see: `fargate-app`

**Step 4**: Check IAM Roles
- Go to: https://console.aws.amazon.com/iam/
- Click "Roles"
- Should see roles starting with `fargate-app-`

**Step 5**: Check Load Balancer
- Go to: https://console.aws.amazon.com/ec2/
- Click "Load Balancers" (left sidebar)
- Should see: `fargate-app-alb`

---

## 7. Push Initial Docker Image

### 7.1 Build Docker Image Locally (Test)

**Step 1**: Navigate to app directory
```powershell
cd E:\SLTC\CODES\CID_CA1\app
```

**Step 2**: Build the image
```powershell
docker build -t fargate-app .
```

**Step 3**: Wait for build
- Docker will download base image (first time only)
- Then build your application
- Should complete in 1-2 minutes

**Step 4**: Verify image created
```powershell
docker images
```
- Should see `fargate-app` in the list

**Step 5**: Test locally (optional)
```powershell
docker run -p 8080:8080 fargate-app
```
- Open browser: http://localhost:8080
- Should see your application
- Press `Ctrl+C` to stop

---

### 7.2 Login to Amazon ECR

**Step 1**: Get ECR repository URL
- From terraform outputs: `ecr_repository_url`
- Example: `123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-app`
- Extract just the domain part: `123456789012.dkr.ecr.us-east-1.amazonaws.com`

**Step 2**: Get your AWS region
- From terraform.tfvars: `aws_region`
- Example: `us-east-1`

**Step 3**: Login to ECR
```powershell
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
```

**Replace**:
- `us-east-1` with your region
- `123456789012.dkr.ecr.us-east-1.amazonaws.com` with your ECR domain

**Step 4**: Verify login success
- Should see: `Login Succeeded`
- If error: Check AWS credentials and region

---

### 7.3 Tag Docker Image

**Step 1**: Get full ECR repository URL
- From terraform output: `ecr_repository_url`
- Example: `123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-app`

**Step 2**: Tag the image
```powershell
docker tag fargate-app:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-app:latest
```

**Replace** the ECR URL with your actual URL.

**Step 3**: Verify tag
```powershell
docker images
```
- Should see both `fargate-app:latest` and your ECR tagged image

---

### 7.4 Push Image to ECR

**Step 1**: Push the image
```powershell
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/fargate-app:latest
```

**Replace** with your actual ECR URL.

**Step 2**: Wait for push
- First push may take 2-3 minutes
- Docker will upload all layers
- You'll see progress like:
  ```
  The push refers to repository [...]
  abc123: Pushing [========>] 5.2MB/10MB
  ```

**Step 3**: Verify in AWS Console
- Go to: https://console.aws.amazon.com/ecr/
- Click on `fargate-app` repository
- Should see image with tag `latest`
- Click on it to see details

---

## 8. Configure GitHub Actions Secret

### 8.1 Navigate to GitHub Repository Settings

**Step 1**: Open your repository
- Go to: https://github.com/lakshanaat99/Assignment_01

**Step 2**: Go to Settings
- Click "Settings" tab (top of repository page)
- If you don't see Settings, make sure you're the owner

**Step 3**: Navigate to Secrets
- In left sidebar, click "Secrets and variables"
- Click "Actions"

---

### 8.2 Add AWS_ROLE_ARN Secret

**Step 1**: Click "New repository secret"
- Button is on the right side of the page

**Step 2**: Enter secret name
- Name: `AWS_ROLE_ARN`
- Must be exactly this (case-sensitive)

**Step 3**: Enter secret value
- Get the value from terraform output: `github_actions_role_arn`
- Example: `arn:aws:iam::123456789012:role/fargate-app-github-actions-role`
- Paste the full ARN

**Step 4**: Click "Add secret"
- Secret is now saved
- You won't be able to see the value again (only update or delete)

**Step 5**: Verify secret exists
- Should see `AWS_ROLE_ARN` in the secrets list
- Shows as `••••••••` (hidden)

---

## 9. Test Local Application

### 9.1 Test Node.js Application

**Step 1**: Navigate to app directory
```powershell
cd E:\SLTC\CODES\CID_CA1\app
```

**Step 2**: Install dependencies
```powershell
npm install
```

**Step 3**: Start the application
```powershell
npm start
```

**Step 4**: Test in browser
- Open: http://localhost:8080
- Should see the application page with your name
- Test health: http://localhost:8080/health

**Step 5**: Stop the application
- Press `Ctrl+C` in PowerShell

---

### 9.2 Test Docker Container

**Step 1**: Build image (if not already done)
```powershell
docker build -t fargate-app .
```

**Step 2**: Run container
```powershell
docker run -p 8080:8080 fargate-app
```

**Step 3**: Test in browser
- Open: http://localhost:8080
- Should see the same application

**Step 4**: Test health endpoint
- Open: http://localhost:8080/health
- Should see JSON response

**Step 5**: Stop container
- Press `Ctrl+C`

---

## 10. Trigger CI/CD Pipeline

### 10.1 Make a Change to Trigger Pipeline

**Step 1**: Update student name (if not done)
- Edit `app/server.js`
- Change `STUDENT_NAME` to your name
- Save the file

**Step 2**: Stage changes
```powershell
cd E:\SLTC\CODES\CID_CA1
git add app/server.js
```

**Step 3**: Commit changes
```powershell
git commit -m "Update student name and trigger deployment"
```

**Step 4**: Push to GitHub
```powershell
git push origin main
```

---

### 10.2 Monitor GitHub Actions Workflow

**Step 1**: Go to Actions tab
- In GitHub repository, click "Actions" tab

**Step 2**: Watch the workflow
- Should see a new workflow run starting
- Click on it to see details

**Step 3**: Monitor progress
- Watch each step:
  1. Checkout code ✅
  2. Configure AWS credentials ✅
  3. Login to ECR ✅
  4. Build and push image ✅
  5. Download task definition ✅
  6. Update task definition ✅
  7. Deploy to ECS ✅

**Step 4**: Wait for completion
- Total time: 5-10 minutes
- The "Deploy" step takes the longest (waits for service stability)

**Step 5**: Check for errors
- If any step fails (red X), click on it to see error
- Common issues:
  - Wrong ECR repository name
  - Wrong ECS service name
  - Missing permissions
  - Image not found

**Step 6**: Verify success
- Should see green checkmarks on all steps
- Final step: "Deployment Summary"

---

## 11. Verify Deployment

### 11.1 Check ECS Service

**Step 1**: Go to ECS Console
- https://console.aws.amazon.com/ecs/
- Click "Clusters"
- Click `fargate-app-cluster`

**Step 2**: Check Service
- Click "Services" tab
- Click `fargate-app-service`

**Step 3**: Verify Tasks
- Click "Tasks" tab
- Should see 2 tasks (or your desired_count)
- Status should be "Running"
- Health status should be "Healthy"

**Step 4**: Check Logs
- Click on a task
- Click "Logs" tab
- Should see application logs
- Look for: "Server is running on port 8080"

---

### 11.2 Check Application Load Balancer

**Step 1**: Get ALB URL
- From terraform output: `alb_url`
- Or from ECS service → Load balancing tab

**Step 2**: Test in browser
- Open the ALB URL in browser
- Should see your application
- Should display your name

**Step 3**: Test health endpoint
- Open: `http://<alb-url>/health`
- Should see JSON response:
  ```json
  {
    "status": "healthy",
    "timestamp": "...",
    "uptime": 123.45,
    "environment": "prod"
  }
  ```

**Step 4**: Check target group health
- Go to: https://console.aws.amazon.com/ec2/
- Click "Target Groups" (left sidebar)
- Click `fargate-app-tg`
- Click "Targets" tab
- Should see targets with "healthy" status

---

### 11.3 Verify ECR Image

**Step 1**: Go to ECR Console
- https://console.aws.amazon.com/ecr/
- Click on `fargate-app` repository

**Step 2**: Check images
- Should see images with tags:
  - `latest`
  - Commit SHA (e.g., `abc123def456...`)

**Step 3**: Verify image details
- Click on an image
- Should see:
  - Image URI
  - Pushed date
  - Image size
  - Scan status

---

## 12. Take Screenshots for Submission

### 12.1 Screenshot 1: Successful GitHub Actions Run

**Step 1**: Go to Actions
- https://github.com/lakshanaat99/Assignment_01/actions
- Click on the latest successful run

**Step 2**: Take screenshot
- Show all steps with green checkmarks
- Include the workflow name and status
- Make sure "Deploy Amazon ECS task definition" step is visible

**Step 3**: Save
- Filename: `github-actions-success.png`

---

### 12.2 Screenshot 2: ECS Service with Running Tasks

**Step 1**: Go to ECS Console
- https://console.aws.amazon.com/ecs/
- Navigate to cluster → service

**Step 2**: Take screenshot
- Show:
  - Service name
  - Running tasks count
  - Task status (Running)
  - Health status
- Include the Tasks tab showing running tasks

**Step 3**: Save
- Filename: `ecs-service-running.png`

---

### 12.3 Screenshot 3: ECR Repository with Images

**Step 1**: Go to ECR Console
- https://console.aws.amazon.com/ecr/
- Click on `fargate-app` repository

**Step 2**: Take screenshot
- Show:
  - Repository name
  - Image tags (latest and commit SHA)
  - Image details

**Step 3**: Save
- Filename: `ecr-images.png`

---

### 12.4 Screenshot 4: Application Accessible in Browser

**Step 1**: Open ALB URL
- From terraform output or ECS service

**Step 2**: Take screenshot
- Show:
  - Browser address bar with URL
  - Application page
  - Your name displayed on the page
  - Full page visible

**Step 3**: Save
- Filename: `application-browser.png`

---

### 12.5 Screenshot 5: Health Check Endpoint

**Step 1**: Open health endpoint
- URL: `http://<alb-url>/health`

**Step 2**: Take screenshot
- Show:
  - Browser address bar
  - JSON response
  - Status: "healthy"

**Step 3**: Save
- Filename: `health-check.png`

---

## ✅ Final Checklist

Before submission, verify:

- [ ] All tools installed (AWS CLI, Terraform, Docker)
- [ ] AWS CLI configured
- [ ] Student name updated in `app/server.js`
- [ ] Terraform variables configured
- [ ] Infrastructure deployed successfully
- [ ] Initial Docker image pushed to ECR
- [ ] GitHub Actions secret configured
- [ ] CI/CD pipeline ran successfully
- [ ] Application accessible via ALB URL
- [ ] Health check endpoint working
- [ ] All 5 screenshots taken
- [ ] Code committed and pushed to GitHub

---

## 🆘 Troubleshooting Common Issues

### Issue: Terraform apply fails

**Possible causes:**
- Insufficient AWS permissions
- Region not available
- Resource limits exceeded

**Solutions:**
- Check IAM user has `AdministratorAccess` policy
- Try different region
- Check service quotas in AWS Console

---

### Issue: Docker build fails

**Possible causes:**
- Dockerfile syntax error
- Missing files
- Network issues

**Solutions:**
- Check Dockerfile syntax
- Verify all files in `app/` directory
- Check internet connection

---

### Issue: GitHub Actions fails

**Possible causes:**
- Wrong `AWS_ROLE_ARN` secret
- OIDC not configured
- Wrong ECS/ECR names

**Solutions:**
- Verify secret value matches terraform output
- Check IAM role exists in AWS
- Verify workflow variables match terraform outputs

---

### Issue: Application not accessible

**Possible causes:**
- Tasks not running
- Security group misconfiguration
- ALB not configured

**Solutions:**
- Check ECS tasks are running
- Verify security groups allow traffic
- Check ALB target group health

---

## 📚 Additional Resources

- **Terraform Docs**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **AWS ECS Docs**: https://docs.aws.amazon.com/ecs/
- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **Docker Docs**: https://docs.docker.com/

---

## 🎉 Congratulations!

If you've completed all steps, your application is now:
- ✅ Deployed to AWS ECS Fargate
- ✅ Accessible via Application Load Balancer
- ✅ Automatically deploying on every push to main
- ✅ Fully production-ready

**You're ready to submit your assignment!** 🚀

---

**Need help?** Review the troubleshooting section or check the other documentation files:
- `SETUP_CHECKLIST.md` - Quick checklist
- `DEPLOYMENT_GUIDE.md` - Deployment details
- `README.md` - Full documentation
