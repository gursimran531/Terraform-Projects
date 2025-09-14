output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value = [for s in aws_subnet.public_subnets : s.id]
}

output "app_subnet_ids" {
  description = "The IDs of the application subnets"
  value = [for s in aws_subnet.app_subnets : s.id]
}

output "db_subnet_ids" {
  description = "The IDs of the database subnets"
  value = [for s in aws_subnet.db_subnets : s.id]
}

