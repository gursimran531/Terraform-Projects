output "instance_profile_arn" {
  description = "The ARN of the instance profile to be used for EC2 instances"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}
