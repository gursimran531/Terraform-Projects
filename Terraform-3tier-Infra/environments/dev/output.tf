output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = var.create_rds ? module.rds.rds_endpoint : "RDS not created"
}

output "alb_website" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for monitoring"
  value       = module.monitoring.s3_bucket_name
}

output "iam_profile" {
  description = "The ARN of the IAM instance profile"
  value       = module.iam.instance_profile_arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "cw_log_group" {
  description = "The name of the CloudWatch log group"
  value       = module.monitoring.cw_log_group_name
}

output "Domain_Website" {
  description = "The domain name for the website"
  value       = module.dns.fqdomain
}