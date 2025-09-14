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

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB to point the record to"
  type        = string
}

variable "alb_zone_id" {
  description = "The hosted zone ID of the ALB"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}