resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "Terraform and AWS Demo VPC"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name    = "Public Subnet 1"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name    = "Public Subnet 2"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name    = "Private Subnet 1"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  tags = {
    Name    = "Private Subnet 2"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "Demo Project Internet Gateway"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "Demo Project Route Table"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name    = "Project NAT EIP"
    Project = "Terraform and AWS Demo"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.allocation_id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name    = "Project Nat Gateway"
    Project = "Terraform and AWS Demo"
  }
}