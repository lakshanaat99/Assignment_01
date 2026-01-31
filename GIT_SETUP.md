# Git Setup Instructions

## Add Your GitHub Remote

If you've already created a GitHub repository, add it as a remote:

```bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
```

Or if using SSH:
```bash
git remote add origin git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git
```

## Push to GitHub

After adding the remote, push your code:

```bash
# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

## If You Haven't Created a GitHub Repository Yet

1. Go to https://github.com
2. Click the "+" icon → "New repository"
3. Name it (e.g., "aws-fargate-deployment")
4. **Don't** initialize with README, .gitignore, or license (we already have these)
5. Click "Create repository"
6. Then follow the commands above to add remote and push

## Verify Remote

Check if remote is configured:
```bash
git remote -v
```

## Next Steps After Pushing

1. **Update your name** in `app/server.js`:
   ```javascript
   const STUDENT_NAME = "Your Actual Name";
   ```

2. **Configure Terraform variables**:
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your values, especially github_repo
   ```

3. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform apply
   ```

4. **Add GitHub secret**:
   - Go to your repo → Settings → Secrets → Actions
   - Add `AWS_ROLE_ARN` with value from terraform output

5. **Push again** to trigger the workflow:
   ```bash
   git add .
   git commit -m "Update student name and configuration"
   git push origin main
   ```
