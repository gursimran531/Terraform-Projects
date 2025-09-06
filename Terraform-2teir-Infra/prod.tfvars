awsregion = "us-east-1"

environment = "prod"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidr = "10.0.1.0/24"

private_subnet_cidr = "10.0.2.0/24"

ec2type = "t2.micro"

keyname = "my-ec2-key"

instances = {
  appserver-1 = {
    ami            = "ami-0a232144cf20a27a5"
    instance_type  = "t2.micro"
    key_name       = "my-ec2-key"
    user_data_file = "./scripts/nginx.sh"
  }

  appserver-2 = {
    ami            = "ami-0a232144cf20a27a5"
    instance_type  = "t2.micro"
    key_name       = "my-ec2-key"
    user_data_file = "./scripts/httpd.sh"
  }

}

dev_ip_cidr = "223.130.31.61/32"