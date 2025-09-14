output "s3_bucket_name" {
  description = "The ARN of the S3 bucket for ALB logs"
  value       = aws_s3_bucket.alb_logs.bucket
}

output "cw_log_group_name" {
  description = "The name of the CloudWatch log group for ALB logs"
  value       = aws_cloudwatch_log_group.asg_log_group.name
}