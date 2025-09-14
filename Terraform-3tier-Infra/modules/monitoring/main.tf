# S3 bucket for ALB logs
resource "random_id" "bucket_id" {
  byte_length = 6
}
resource "aws_s3_bucket" "alb_logs" {
  bucket = "alb-logs-${var.environment}-${random_id.bucket_id.hex}"

  tags = merge(
    { Name = "ALB-Logs-${var.environment}" },
    var.tags
  )
}

# Caller identity (gets AWS account ID dynamically)
data "aws_caller_identity" "current" {}

# Bucket policy allowing ALB logs
resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = ["${aws_s3_bucket.alb_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        "${aws_s3_bucket.alb_logs.arn}/alb-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.alb_logs.arn
      }
    ]
  })
}

# CloudWatch Log Group for ASG instances
resource "aws_cloudwatch_log_group" "asg_log_group" {
  name              = "/ec2/asg-app-${var.environment}"
  retention_in_days = 30
  tags = merge(
    {
      Name = "ASG-App-LogGroup-${var.environment}"
    },
    var.tags
  )
}