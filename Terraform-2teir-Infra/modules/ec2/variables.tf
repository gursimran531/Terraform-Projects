variable "instances" {
  description = "Specify ami,subnet id and instance type to be used for each instance"
  type = map(object({
    ami            = string
    instance_type  = string
    key_name       = string
    user_data_file = optional(string, "")
  }))
}

variable "tags" {
  description = "Common tags to be associated with the resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "Specify the VPC ID"
  type        = string
}

variable "bastionsg" {
  description = "Specify the SG ID associated with Bastion Host"
  type        = string
}

variable "vpc_cidr" {
  description = "Specify the VPC CIDR IPv4"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Provide a valid CIDR block for vpc CIDR"
  }
}

variable "private_subnet_id" {
  description = "Private Subnet ID of the VPC"
  type        = string
}