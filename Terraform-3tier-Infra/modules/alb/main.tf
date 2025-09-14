# Application Load Balancer (ALB) Resource
resource "aws_lb" "alb" {
  name               = "App-ALB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
  access_logs {
    bucket  = var.s3_bucket_name
    enabled = true
    prefix  = "alb-logs"
  }

  tags = merge(
    { "Name" = "App-ALB-${var.environment}" },
    var.tags
  )
}

# Target Group for ALB
resource "aws_lb_target_group" "tg" {
  name        = "App-TG"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = merge(
    { Name = "App-TG-${var.environment}" },
    var.tags
  )
}

# Application Load Balancer Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "ALB-SG"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      Name = "ALB-SG-${var.environment}"
    },
    var.tags
  )
}

# Allow HTTP and HTTPS from anywhere and outbound to ASG security group
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTP traffic from anywhere"
}
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS traffic from anywhere"
}
resource "aws_vpc_security_group_egress_rule" "allow_http" {
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = var.asg_security_group_id
  description                  = "Allow Outbound HTTP traffic from within ASG to ALB"
}
resource "aws_vpc_security_group_egress_rule" "allow_https" {
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = var.asg_security_group_id
  description                  = "Allow Outbound HTTPS traffic from within ASG to ALB"
}