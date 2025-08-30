variable "instance_type" {
    description = "Value of instance's type"
    type        = string
    default     = "t2.micro"
}

variable "subnet_id" {
    description = "Subnet ID to be associated with EC2 instance"
    type        = string
}

variable "vpc_id" {
    description = "VPC ID to be associated with EC2 instance"
    type        = string
}

variable "key_name" {
    description = "SSH key pair ID for EC2 Instance"
    type        = string
}