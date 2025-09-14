# Data source to fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
  owners = [137112412989] # Amazon

}

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "application" {
  name_prefix   = "APP-Launch-Template"
  image_id      = var.image_id != "" ? var.image_id : data.aws_ami.linux.id # Use provided AMI ID or latest Amazon Linux 2023 AMI
  instance_type = var.instance_type
  key_name      = "my-ec2-key"
  user_data = base64encode(
    templatefile(var.user_data_file, {
      environment = var.environment
    })
  )
  iam_instance_profile {
    arn = var.instance_profile_arn
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.asg_sg.id]
  }
  tags = merge(
    {
      Name = "ASG-LT-${var.environment}"
    },
    var.tags
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg_app" {
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }
  target_group_arns         = [var.tg_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
}

# Security Group for the Auto Scaling Group instances
resource "aws_security_group" "asg_sg" {
  name        = "asg_app_sg"
  description = "Security group for ASG application instances"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      Name = "asg_app_sg-${var.environment}"
    },
    var.tags
  )
}

# Allow HTTP and HTTPS from ALB security group and outbound to RDS security group
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.asg_sg.id
  referenced_security_group_id = var.alb_sg
  description                  = "Allow HTTPS traffic from within ASG to ALB"
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.asg_sg.id
  referenced_security_group_id = var.alb_sg
  description                  = "Allow HTTP traffic from within ASG to ALB"
}
resource "aws_vpc_security_group_egress_rule" "allow_rds" {
  count                        = var.create_rds ? 1 : 0
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.asg_sg.id
  referenced_security_group_id = var.rds_sg
  description                  = "Allow HTTP traffic from within ASG to ALB"
}
resource "aws_vpc_security_group_egress_rule" "allow_https" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.asg_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS traffic outbound to connect to NAT"
}
resource "aws_vpc_security_group_egress_rule" "allow_http" {
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.asg_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTP traffic outbound to connect to NAT"
}