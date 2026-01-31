output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.app[0].dns_name : "ALB not enabled"
}

output "alb_url" {
  description = "URL to access the application"
  value       = var.enable_alb ? "http://${aws_lb.app[0].dns_name}" : "ALB not enabled"
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = var.github_repo != "" ? aws_iam_role.github_actions[0].arn : "GitHub repo not configured"
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
