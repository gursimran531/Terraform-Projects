# Query the latest Linux 2 AMI to be used for bastion host
data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
  owners = [137112412989] # Amazon

}

# Creating the Bastion instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.linux.id
  instance_type          = var.ec2type
  subnet_id              = var.publicsubnetID
  vpc_security_group_ids = [aws_security_group.ssh.id]
  key_name               = var.keyname


  tags = merge(
    {
      Name = "Bastion Host"
    },
    var.tags
  )
}

resource "aws_security_group" "ssh" {
  name        = "Allowssh"
  description = "Allow ssh from dev ip"
  vpc_id      = var.vpcid

  tags = merge(
    {
      Name = "Allow SSH for Bastion"
    },
    var.tags
  )

}

resource "aws_vpc_security_group_ingress_rule" "sshrule" {
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4         = var.devip
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}