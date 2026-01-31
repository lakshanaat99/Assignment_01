# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.app_name}-logs"
  }
}

# ECS Cluster using the public ECS module
module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"

  cluster_name = "${var.app_name}-cluster"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.app.name
      }
    }
  }

  # Fargate capacity providers
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 0
      }
    }
  }

  tags = {
    Name = "${var.app_name}-cluster"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = "${aws_ecr_repository.app.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "PORT"
          value = tostring(var.app_port)
        },
        {
          name  = "NODE_ENV"
          value = var.environment
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "node -e \"require('http').get('http://localhost:${var.app_port}/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})\""]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = {
    Name = "${var.app_name}-task-definition"
  }
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = var.enable_alb ? [1] : []
    content {
      target_group_arn = aws_lb_target_group.app[0].arn
      container_name   = var.app_name
      container_port   = var.app_port
    }
  }

  depends_on = [
    aws_ecs_task_definition.app
  ]

  tags = {
    Name = "${var.app_name}-service"
  }
}
