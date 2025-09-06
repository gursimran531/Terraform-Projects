variable "awsregion" {
  description = "Specify AWS region for the resources to be provisioned in"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Specify the Environment name"
  type        = string
  default     = "test"
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

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
  validation {
    condition     = can(cidrnetmask(var.public_subnet_cidr))
    error_message = "Specify a valid CIDR block for Public Subnet"
  }
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
  default     = "10.0.2.0/24"
  validation {
    condition     = can(cidrnetmask(var.private_subnet_cidr))
    error_message = "Specify a valid CIDR block for Private Subnet"
  }
}

variable "ec2type" {
  description = "Instnace type of bastion Host"
  type        = string
  default     = "t2.micro"
  validation {
    condition     = can(regex("^t2\\.[a-z0-9]+$", var.ec2type))
    error_message = "Please use t2 instance type only"
  }
}


variable "instances" {
  description = "Specify ami,subnet id and instance type to be used for each instance"
  type = map(object({
    ami            = string
    instance_type  = string
    key_name       = string
    user_data_file = optional(string, "")
  }))
}

variable "keyname" {
  description = "Specify the key pair for Bastion Host"
  type        = string
  default     = "my-ec2-key"
}

variable "dev_ip_cidr" {
  description = "Specify your home/work IP CIDR"
  type        = string
}