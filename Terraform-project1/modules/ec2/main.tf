data "aws_ami" "linux" {
    most_recent = true

    filter {
        name   = "name"
        values = ["al2023-ami-*-kernel-6.1-x86_64"]
    }
    owners = [137112412989] # Amazon

}

resource "aws_instance" "nginx_server" {
    ami             = data.aws_ami.linux.id
    instance_type   = var.instance_type
    subnet_id       = var.subnet_id
    vpc_security_group_ids = [aws_security_group.ec2sg.id]
    user_data       = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install nginx -y
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<h1>Hello, from Terraform!</h1>" | sudo tee /var/www/html/index.html
                EOF
}

resource "aws_security_group" "ec2sg" {
    name        = "AllowSSHandHTTP"
    description = "Allow SSH and HTTP from anywhere"
    vpc_id      = var.vpc_id

    tags = {
        Name = "AllowSSHandHTTP"
    }
}

resource "aws_vpc_security_group_ingress_rule" "Allowssh" {
    security_group_id = aws_security_group.ec2sg.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 22
    ip_protocol = "tcp"
    to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "Allowhttp" {
    security_group_id = aws_security_group.ec2sg.id

    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "AllowAllEgress" {
    security_group_id = aws_security_group.ec2sg.id

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "-1"
}