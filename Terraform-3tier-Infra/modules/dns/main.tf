# Create or use existing Route 53 hosted zone
resource "aws_route53_zone" "primary" {
  count = var.create_dns_zone ? 1 : 0
  name  = var.domain

  tags = merge(
    {
      Name = "primary-zone-${var.environment}"
    },
    var.tags
  )
}

# If not creating a new zone, look up the existing one
data "aws_route53_zone" "primary" {
  count = var.create_dns_zone ? 0 : 1
  name  = var.domain
}

# Local values for DNS zone ID and subdomain
locals {
  dns_zone_id = var.create_dns_zone ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.primary[0].zone_id
  subdomain   = var.environment == "production" ? "" : "${var.environment}."
}

# Create Alias record pointing to ALB
resource "aws_route53_record" "root" {
  zone_id = local.dns_zone_id
  name    = "${local.subdomain}${var.domain}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}