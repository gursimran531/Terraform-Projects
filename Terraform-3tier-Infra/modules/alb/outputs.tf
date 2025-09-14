output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.alb.id
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_sg" {
  description = "The security group ID associated with the Application Load Balancer"
  value       = aws_security_group.alb_sg.id
}

output "tg_arn" {
  description = "The ARN of the target group associated with the Application Load Balancer"
  value       = aws_lb_target_group.tg.arn
}

output "alb_zone_id" {
  description = "The hosted zone ID of the Application Load Balancer"
  value       = aws_lb.alb.zone_id
}