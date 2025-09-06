output "eip_of_nat" {
  value = aws_eip.eip
}

output "public_subnet" {
  value = aws_subnet.PublicSubnet.id
}
output "private_subnet" {
  value = aws_subnet.PrivateSubnet.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}