output "fqdomain" {
  description = "The domain name for the website"
  value       = trim(aws_route53_record.root.fqdn)
}