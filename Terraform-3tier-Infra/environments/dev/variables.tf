variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "The CIDR block and AZs for the public subnets"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "app_subnets" {
  description = "The CIDR block and AZs for the app subnets"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.4.0/24"
    "us-east-1b" = "10.0.5.0/24"
  }
}

variable "db_subnets" {
  description = "The CIDR block and AZs for the db subnets"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.6.0/24"
    "us-east-1b" = "10.0.7.0/24"
  }
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Whether to create a Multi-AZ RDS instance"
  type        = bool
  default     = true
}

variable "rds_instance_type" {
  description = "The instance type for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "image_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "asg_instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
  validation {
    condition     = can(regex("^t2\\.[a-z0-9]+$", var.asg_instance_type))
    error_message = "Please use t2 instance type only"
  }
}

variable "user_data_file" {
  description = "Path to the user data script file"
  type        = string
  default     = "./scripts/nginx-cw.sh"
}

variable "awsregion" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "create_rds" {
  description = "Specify to create RDS (true or false)"
  type        = bool
  default     = false
}

variable "create_dns_zone" {
  description = "Specify to create DNS zone (true or false)"
  type        = bool
  default     = false
}

variable "domain" {
  description = "The domain name for the Route 53 zone"
  type        = string
  default     = "techscholarrentals.click"
}