variable "tags" {
  description = "For dynamic tagging"
  type        = map(string)
  default     = {}
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the ALB and its security group will be created"
  type        = string
}

variable "asg_security_group_id" {
  description = "The security group ID of the ASG to allow traffic from"
  type        = string
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}



variable "s3_bucket_name" {
  description = "The name of the S3 bucket for ALB access logs"
  type        = string
}