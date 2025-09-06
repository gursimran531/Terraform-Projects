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

variable "tags" {
  description = "For dynamic tagging"
  type        = map(string)
  default     = {}
}
