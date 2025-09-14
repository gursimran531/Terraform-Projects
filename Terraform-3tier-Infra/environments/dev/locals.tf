locals {
  common_tags = {
    Project     = "terraform-aws-3tier-infra"
    Environment = var.environment
    Owner       = "Gursimran"
  }
}
