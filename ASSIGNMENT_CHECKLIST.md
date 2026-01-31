# Assignment 1 Checklist

Use this checklist to ensure you've completed all requirements for the assignment.

## ✅ Required Components

### 1. Terraform Infrastructure (40 marks)

- [x] VPC with public and private subnets
- [x] ECS Fargate cluster (using public ECS terraform module)
- [x] ECR repository with lifecycle policies
- [x] IAM roles and policies (task execution, task role, GitHub Actions)
- [x] Security groups for ALB and ECS
- [x] Application Load Balancer (optional but recommended)
- [x] CloudWatch log groups
- [x] NAT Gateways for private subnet internet access

**Files:**
- `terraform/main.tf`
- `terraform/variables.tf`
- `terraform/vpc.tf`
- `terraform/ecr.tf`
- `terraform/ecs.tf`
- `terraform/iam.tf`
- `terraform/security_groups.tf`
- `terraform/alb.tf`
- `terraform/outputs.tf`

### 2. Application & Docker (10 marks)

- [x] Node.js application listening on port 8080
- [x] Health check endpoint at `/health`
- [x] Dockerfile with best practices
- [x] Application displays student name
- [x] Application accessible and functional

**Files:**
- `app/server.js`
- `app/package.json`
- `app/Dockerfile`
- `app/.dockerignore`

**Action Required:**
- [ ] Update `STUDENT_NAME` in `app/server.js` with your actual name

### 3. CI/CD Pipeline - GitHub Actions (30 marks)

- [x] Workflow triggers on push to main branch
- [x] Secure AWS authentication (OIDC)
- [x] Docker image build
- [x] Push to Amazon ECR
- [x] Update ECS task definition
- [x] Deploy to ECS Fargate service
- [x] Wait for service stability

**Files:**
- `.github/workflows/deploy.yml`

**Action Required:**
- [ ] Configure `AWS_ROLE_ARN` secret in GitHub repository
- [ ] Verify workflow variables match your setup

### 4. Documentation (10 marks)

- [x] Comprehensive README.md
- [x] Architecture overview/diagram
- [x] CI/CD pipeline explanation
- [x] How to test the application
- [x] Deployment instructions
- [x] Troubleshooting guide

**Files:**
- `README.md`
- `DEPLOYMENT_GUIDE.md`
- `QUICK_START.md`

### 5. Advanced Implementation (10 marks)

- [x] Application Load Balancer integration
- [x] Health checks configured (ALB and ECS)
- [x] ECS service accessible via port 80 (through ALB)
- [x] Multi-AZ deployment for high availability
- [x] Security best practices
- [x] Cost optimization (ECR lifecycle policies)

## 📋 Submission Checklist

### Before Submission

- [ ] All code is committed to GitHub repository
- [ ] Repository is public or shared with instructor
- [ ] Student name is updated in `app/server.js`
- [ ] All Terraform variables are configured
- [ ] GitHub Actions workflow is tested and working
- [ ] Application is deployed and accessible

### Required Screenshots

- [ ] Successful GitHub Actions workflow run
- [ ] ECS service with running tasks (AWS Console)
- [ ] ECR repository with image tags
- [ ] Application accessible via browser (showing your name)
- [ ] Health check endpoint response
- [ ] ALB target group showing healthy targets

### Repository Structure Verification

```
/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── iam.tf
│   ├── security_groups.tf
│   ├── alb.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── app/
│   ├── server.js
│   ├── package.json
│   ├── package-lock.json
│   ├── Dockerfile
│   └── .dockerignore
├── .github/
│   └── workflows/
│       └── deploy.yml
├── README.md
├── DEPLOYMENT_GUIDE.md
├── QUICK_START.md
├── ASSIGNMENT_CHECKLIST.md
└── .gitignore
```

### Security Checklist

- [ ] No AWS credentials in code
- [ ] No secrets committed to repository
- [ ] OIDC authentication configured
- [ ] Security groups properly configured
- [ ] IAM roles follow least privilege principle
- [ ] ECS tasks in private subnets

## 🧪 Testing Checklist

### Local Testing

- [ ] Application runs locally: `npm start`
- [ ] Health endpoint works: `curl http://localhost:8080/health`
- [ ] Docker image builds: `docker build -t app .`
- [ ] Docker container runs: `docker run -p 8080:8080 app`

### AWS Deployment Testing

- [ ] Terraform applies successfully
- [ ] ECR repository created
- [ ] ECS cluster created
- [ ] Docker image pushed to ECR
- [ ] ECS service running
- [ ] Tasks are healthy
- [ ] ALB is accessible
- [ ] Application responds at ALB URL
- [ ] Health check returns 200 OK

### CI/CD Testing

- [ ] Push to main triggers workflow
- [ ] Workflow completes successfully
- [ ] New image is pushed to ECR
- [ ] ECS service updates with new task definition
- [ ] Service reaches stable state
- [ ] Application accessible after deployment

## 📝 Final Steps

1. **Update Student Name**
   ```bash
   # Edit app/server.js
   const STUDENT_NAME = "Your Actual Name";
   ```

2. **Test Everything**
   - Run through QUICK_START.md
   - Verify all endpoints work
   - Check all screenshots can be taken

3. **Take Screenshots**
   - GitHub Actions successful run
   - ECS console showing running tasks
   - ECR console showing images
   - Browser showing application with your name
   - Health check response

4. **Final Commit**
   ```bash
   git add .
   git commit -m "Assignment 1 - Final submission"
   git push origin main
   ```

5. **Submit**
   - GitHub repository link
   - Screenshots as evidence
   - Any additional notes

## 🎯 Marking Scheme Reference

- **Terraform Infrastructure** - 40 marks
- **Application & Docker** - 10 marks
- **CI/CD (GitHub Actions)** - 30 marks
- **Documentation** - 10 marks
- **Advanced Implementation** - 10 marks

**Total: 100 marks**

## 💡 Tips for Full Marks

1. **Documentation**: Be thorough in README.md
2. **Architecture**: Include clear diagrams or explanations
3. **Security**: Show understanding of best practices
4. **Testing**: Provide clear testing instructions
5. **Advanced Features**: ALB, health checks, multi-AZ deployment
6. **Code Quality**: Clean, well-commented code
7. **Evidence**: Clear, labeled screenshots

## ❓ Common Issues

- **OIDC not working**: Check IAM role trust policy
- **Tasks not starting**: Check CloudWatch logs
- **ALB not accessible**: Check security groups
- **Workflow fails**: Check GitHub secrets

See DEPLOYMENT_GUIDE.md for detailed troubleshooting.

---

**Good luck with your submission! 🚀**
