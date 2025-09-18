output "fqdomain" {
  description = "The domain name for the website"
  value       = trim(tostring(aws_route53_record.root.fqdn), " \t\n")
}