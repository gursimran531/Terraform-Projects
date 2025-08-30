variable "vpc_cidr_block" {
    description = "Specify the CIDR block to be used for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}


variable "subnet_cidr_block" {
    description = "Specify the CIDR block to be assosciated to the Subnet"
    type        = string
    default     = "10.0.1.0/24"
}

variable "instance_type" {
    description = "Specify instance type for EC2 instance"
    type        = string
    default     = "t2.micro"
}