variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "fargate-app"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "container_cpu" {
  description = "CPU units for the container (1024 = 1 vCPU)"
  type        = number
  default     = 512
}

variable "container_memory" {
  description = "Memory for the container in MB"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 2
}

variable "enable_alb" {
  description = "Enable Application Load Balancer"
  type        = bool
  default     = true
}

variable "github_repo" {
  description = "GitHub repository (e.g., owner/repo)"
  type        = string
  default     = ""
}

variable "github_branch" {
  description = "GitHub branch for OIDC"
  type        = string
  default     = "main"
}
