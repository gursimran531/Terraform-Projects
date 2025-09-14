output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value = var.create_rds ? aws_db_instance.rds_instance[0].endpoint : null
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value = var.create_rds ? aws_db_instance.rds_instance[0].id : null
}

output "rds_sg_id" {
  description = "The security group ID of the RDS instance"
  value = var.create_rds ? aws_security_group.rds_sg[0].id : null
}