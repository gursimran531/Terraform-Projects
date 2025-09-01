output "myinstance_ip" {
  value = module.ec2.ec2_public_ip
}