# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  count      = var.create_rds ? 1 : 0
  name       = "rds-subnet-group-${var.environment}"
  subnet_ids = var.db_subnets

  tags = merge(
    {
      Name = "RDS-Subnet-Group-${var.environment}"
    },
    var.tags
  )

}

# SSM Parameter for RDS password 
resource "aws_ssm_parameter" "db_password" {
  count       = var.create_rds ? 1 : 0
  name        = "/${var.environment}/db/password"
  description = "RDS master password for ${var.environment}"
  type        = "SecureString"
  value       = var.db_password
}


# RDS Instance
resource "aws_db_instance" "rds_instance" {
  count                   = var.create_rds ? 1 : 0
  identifier              = "rds-instance-${var.environment}"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_type
  username                = var.db_username
  password                = var.create_rds ? aws_ssm_parameter.db_password[0].value : null
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = var.create_rds ? [aws_security_group.rds_sg[0].id] : []
  db_subnet_group_name    = var.create_rds ? aws_db_subnet_group.rds_subnet_group[0].name : null
  multi_az                = var.multi_az
  storage_type            = "gp2"
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  tags = merge(
    {
      Name = "RDS-Instance-${var.environment}"
    },
    var.tags
  )
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  count       = var.create_rds ? 1 : 0
  name        = "rds_sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "RDS-SG-${var.environment}"
    },
    var.tags
  )
}
# Allow MySQL access from application servers
resource "aws_vpc_security_group_ingress_rule" "allow_mysql" {
  count                        = var.create_rds ? 1 : 0
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  security_group_id            = var.create_rds ? aws_security_group.rds_sg[0].id : null
  referenced_security_group_id = var.app_sg_id
  description                  = "Allow MySQL access from application servers"
}