output "fqdomain" {
  description = "The domain name for the website"
  value       = aws_route53_record.root.fqdn
}