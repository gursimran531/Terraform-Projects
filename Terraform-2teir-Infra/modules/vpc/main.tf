resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    {
      Name = "VPCji"
    },
    var.tags
  )
}

resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = "true"

  tags = merge(
    {
      Name = "Public Subnet"
    },
    var.tags
  )

}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  tags = merge(
    {
      Name = "Private Subnet"
    },
    var.tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "Main IGW"
    },
    var.tags
  )
}

resource "aws_eip" "eip" {
  domain = "vpc"
  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = merge(
    {
      Name = "EIP for NAT Gateway"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.PublicSubnet.id

  tags = merge(
    {
      Name = "NAT Gateway for internet access"
    },
    var.tags
  )
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    {
      Name = "Public Route Table"
    },
    var.tags
  )

}

resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = merge(
    {
      Name = "Private Route Table"
    },
    var.tags
  )

}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.PrivateSubnet.id
  route_table_id = aws_route_table.PrivateRT.id
}