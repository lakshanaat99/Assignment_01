terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: Configure backend for state management
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "fargate-deployment/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "ECS-Fargate-Deployment"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}
