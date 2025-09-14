output "asg_sg_id" {
  description = "The security group ID of the ASG"
  value       = aws_security_group.asg_sg.id
}