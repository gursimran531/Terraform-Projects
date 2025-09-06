output "ec2_privateip" {
  value = { for k, inst in aws_instance.app_server : k => inst.private_ip }
}