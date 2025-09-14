resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "VPCji-${var.environment}"
    },
    var.tags
  )
}


# Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.public_subnets
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = "true"
  tags = merge(
    {
      Name = "PublicSubnet-${each.key}-${var.environment}"
    },
    var.tags
  )

}

# Private Subnets
resource "aws_subnet" "app_subnets" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.app_subnets
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = "false"
  tags = merge(
    {
      Name = "AppSubnet-${each.key}-${var.environment}"
    },
    var.tags
  )

}

# Database Subnets
resource "aws_subnet" "db_subnets" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.db_subnets
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = "false"
  tags = merge(
    {
      Name = "DBSubnet-${each.key}-${var.environment}"
    },
    var.tags
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "IGW-VPCji-${var.environment}"
    },
    var.tags
  )
}

# One NAT Gateway per AZ in Public Subnets with EIP (Best Practice for HA)
resource "aws_eip" "nat_eip" {
  for_each = var.public_subnets
  domain   = "vpc"
  tags = merge(
    {
      Name = "NatEIP-${each.key}-${var.environment}"
    },
    var.tags
  )
}
resource "aws_nat_gateway" "nat_gw" {
  for_each      = var.public_subnets
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public_subnets[each.key].id
  tags = merge(
    {
      Name = "NatGW-${each.key}-${var.environment}"
    },
    var.tags
  )
  depends_on = [aws_internet_gateway.igw]
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      Name = "PublicRT-${var.environment}"
    },
    var.tags
  )
}
resource "aws_route" "public_rt_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public_rt_assoc" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


# Route Table for App Subnets
resource "aws_route_table" "app_rt" {
  for_each = var.app_subnets
  vpc_id   = aws_vpc.main.id
  tags = merge(
    {
      Name = "AppRT-${each.key}-${var.environment}"
    },
    var.tags
  )
}
resource "aws_route" "app_rt_route" {
  for_each               = var.app_subnets
  route_table_id         = aws_route_table.app_rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[each.key].id
}
resource "aws_route_table_association" "app_rt_assoc" {
  for_each       = aws_subnet.app_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.app_rt[each.key].id
}


# Route Table for DB Subnets
# No internet access for DB subnets
resource "aws_route_table" "db_rt" {
  for_each = var.db_subnets
  vpc_id   = aws_vpc.main.id
  tags = merge(
    {
      Name = "DBRT-${each.key}-${var.environment}"
    },
    var.tags
  )
}
resource "aws_route_table_association" "db_rt_assoc" {
  for_each       = aws_subnet.db_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.db_rt[each.key].id
}


