variable "image_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
  validation {
    condition     = can(regex("^t2\\.[a-z0-9]+$", var.instance_type))
    error_message = "Please use t2 instance type only"
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling group"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "rds_sg" {
  description = "The security group ID for the RDS instance"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "alb_sg" {
  description = "The security group ID for the ALB"
  type        = string
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "instance_profile_arn" {
  description = "The ARN of the IAM instance profile to attach to EC2 instances"
  type        = string
}

variable "tg_arn" {
  description = "The ARN of the target group to attach to the Auto Scaling Group"
  type        = string
}

variable "user_data_file" {
  description = "Path to the user data script file"
  type        = string
  default     = "./scripts/nginx-cw.sh"
}

variable "create_rds" {
  description = "Specify to create RDS (true or false)"
  type        = bool
  default     = false
}