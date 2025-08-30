module "ec2" {
    source = "./modules/ec2"

    #VariableInputs
    key_name = aws_key_pair.sshkey.key_name
    vpc_id = aws_vpc.new_vpc.id
    subnet_id = aws_subnet.public_subnet.id
    instance_type = var.instance_type

}

resource "aws_key_pair" "sshkey" {
    key_name = "my-ec2-key"
    public_key = file("./my-ec2-key.pub")
}

resource "aws_vpc" "new_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "VPCji"
    }
}

resource "aws_internet_gateway" "newgw" {
    vpc_id = aws_vpc.new_vpc.id
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.new_vpc.id
    cidr_block = var.subnet_cidr_block
    map_public_ip_on_launch = true
    tags = {
        Name = "Main_Public_Subnet"
    }
}

resource "aws_route_table" "newrt" {
    vpc_id = aws_vpc.new_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.newgw.id
    }
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.newrt.id
}