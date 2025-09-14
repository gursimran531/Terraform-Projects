variable "tags" {
  description = "For dynamic tagging"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Specify a valid CIDR block for VPC"
  }
}

variable "public_subnets" {
  description = "Specify az and cidr block for each public subnet"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "app_subnets" {
  description = "Specify az and cidr block for each private subnet for app tier"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.3.0/24"
    "us-east-1b" = "10.0.4.0/24"
  }
}

variable "db_subnets" {
  description = "Specify az and cidr block for each private subnet for database tier"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.5.0/24"
    "us-east-1b" = "10.0.6.0/24"
  }
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}