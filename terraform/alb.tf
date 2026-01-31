# Application Load Balancer
resource "aws_lb" "app" {
  count              = var.enable_alb ? 1 : 0
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false
  enable_http2              = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.app_name}-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "app" {
  count                = var.enable_alb ? 1 : 0
  name                 = "${var.app_name}-tg"
  port                 = var.app_port
  protocol             = "HTTP"
  vpc_id               = aws_vpc.main.id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = {
    Name = "${var.app_name}-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "app" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.app[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[0].arn
  }

  tags = {
    Name = "${var.app_name}-listener"
  }
}
