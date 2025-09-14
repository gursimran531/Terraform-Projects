environment = "dev"
vpc_cidr    = "10.0.0.0/16"
public_subnets = {
  "us-east-1a" = "10.0.1.0/24"
  "us-east-1b" = "10.0.2.0/24"
}
app_subnets = {
  "us-east-1a" = "10.0.3.0/24"
  "us-east-1b" = "10.0.4.0/24"
}
db_subnets = {
  "us-east-1a" = "10.0.5.0/24"
  "us-east-1b" = "10.0.6.0/24"
}
db_name           = "mydb"
db_username       = "admin"
multi_az          = true
rds_instance_type = "db.t3.micro"
asg_instance_type = "t2.micro"
awsregion         = "us-east-1"
create_rds        = false
create_dns_zone   = false
domain            = "singhops.net"