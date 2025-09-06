resource "aws_instance" "app_server" {
  for_each = var.instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = var.private_subnet_id
  key_name               = each.value.key_name
  vpc_security_group_ids = [aws_security_group.privatessh.id]
  user_data              = each.value.user_data_file != "" ? file(each.value.user_data_file) : ""

  tags = merge(
    {
      Name = each.key
    },
    var.tags
  )
}


resource "aws_security_group" "privatessh" {
  name        = "SSH-Private"
  description = "SSH from Bastion to app servers"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "SSH-Private"
    },
    var.tags
  )
}

resource "aws_vpc_security_group_ingress_rule" "sshrule" {
  security_group_id            = aws_security_group.privatessh.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
  referenced_security_group_id = var.bastionsg

}
# Allow HTTP within VPC only (for testing purposes)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.privatessh.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4         = var.vpc_cidr
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.privatessh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
