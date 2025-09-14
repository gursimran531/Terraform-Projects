variable "tags" {
  description = "For dynamic tagging"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
}