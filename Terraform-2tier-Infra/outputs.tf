output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eip_of_nat" {
  value = module.vpc.eip_of_nat
}

output "public_subnet" {
  value = module.vpc.public_subnet
}
output "private_subnet" {
  value = module.vpc.private_subnet
}

output "private_ips" {
  value = module.ec2.ec2_privateip
}

output "bastion_ip" {
  value = module.bastion.public_ip
}