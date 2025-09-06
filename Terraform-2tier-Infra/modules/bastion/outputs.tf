output "public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_sg" {
  value = aws_security_group.ssh.id
}