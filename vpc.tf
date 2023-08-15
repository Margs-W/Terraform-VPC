#TIG VPC for Project 7
resource "aws_vpc" "TIG3-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TIG3-vpc"
  }
}
#Public Subnet
resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.TIG3-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Prod-pub-sub1"
  }
}
resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.TIG3-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Prod-pub-sub2"
  }
}
#Private Subnets
resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.TIG3-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Prod-priv-sub1"
  }
}
resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.TIG3-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Prod-priv-sub2"
  }
}
#Public Route
resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.TIG3-vpc.id
  tags   = {
    Name = "Prod-pub-route-table"
  }
}
#Private Route
resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.TIG3-vpc.id
  tags   = {
    Name = "Prod-priv-route-table"
  }
}
#Public subnet association
resource "aws_route_table_association" "TIG-pub-route-association1" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}
resource "aws_route_table_association" "TIG-pub-route-association2" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}
#Private subnet association
resource "aws_route_table_association" "TIG-priv-route-association1" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}
resource "aws_route_table_association" "TIG-priv-route-association2" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}
#Internet Gateway
resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.TIG3-vpc.id

  tags = {
    Name = "Prod-igw"
  }
}
#IGW Route
resource "aws_route" "Prod-igw-association" {
  route_table_id            = aws_route_table.Prod-pub-route-table.id
  gateway_id                = aws_internet_gateway.Prod-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}
#NAT Gateway
resource "aws_nat_gateway" "Prod-Nat-gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Prod-priv-sub1.id
}
#Nat Gateway Route
resource "aws_nat_gateway" "Prod-Nat-association" {
  connectivity_type                  = "private"
  subnet_id                          = aws_subnet.Prod-priv-sub1.id
  secondary_private_ip_address_count = 7
}