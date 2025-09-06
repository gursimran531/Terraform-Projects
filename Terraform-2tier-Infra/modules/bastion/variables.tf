variable "tags" {
  description = "For dynamic tagging"
  type        = map(string)
  default     = {}
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

variable "publicsubnetID" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "vpcid" {
  description = "VPC ID"
  type        = string
}

variable "devip" {
  description = "CIDR block of Developer to access bastion by SSH"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.devip))
    error_message = "Specify a valid CIDR block for your IP"
  }
}

variable "keyname" {
  description = "Specify the key pair for Bastion Host"
  type        = string
  default     = "my-ec2-key"
}