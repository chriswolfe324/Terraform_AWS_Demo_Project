resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "Terraform and AWS Demo VPC"
    Project = var.project_tag_name
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public1_subnet_cidr
  tags = {
    Name    = "Public Subnet 1"
    Project = var.project_tag_name
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public2_subnet_cidr
  tags = {
    Name    = "Public Subnet 2"
    Project = var.project_tag_name
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private1_subnet_cidr
  tags = {
    Name    = "Private Subnet 1"
    Project = var.project_tag_name
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private2_subnet_cidr
  tags = {
    Name    = "Private Subnet 2"
    Project = var.project_tag_name
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "Demo Project Internet Gateway"
    Project = var.project_tag_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "Demo Public Route Table"
    Project = var.project_tag_name
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name    = "Project NAT EIP"
    Project = var.project_tag_name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.allocation_id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name    = "Project Nat Gateway"
    Project = var.project_tag_name
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "Demo Private Route Table"
    Project = var.project_tag_name
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "public_entry" {
  name   = "Public_Entry"
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "Public_Entry"
    Project = var.project_tag_name
  }
}

resource "aws_security_group" "app_servers" {
  name   = "App_Servers"
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "App_Servers"
    Project = var.project_tag_name
  }
}

resource "aws_security_group" "database" {
  name   = "MongoDB"
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "MongoDB"
    Project = var.project_tag_name
  }
}

resource "aws_security_group" "background_workers" {
  name   = "Background_Workers"
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "Background_Workers"
    Project = var.project_tag_name
  }
}


# this rule allows internet traffic in to public_entry
resource "aws_security_group_rule" "public_entry_http" {
  type              = "ingress"
  security_group_id = aws_security_group.public_entry.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}

# this rule allows internet traffic in to public_entry
resource "aws_security_group_rule" "public_entry_https" {
  type              = "ingress"
  security_group_id = aws_security_group.public_entry.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# this rule allows public_entry to communicate with app_servers
resource "aws_security_group_rule" "public_entry_to_app" {
  type                     = "egress"
  security_group_id        = aws_security_group.public_entry.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.app_servers.id
}

# this rule allows app_servers to communicate with public_entry
resource "aws_security_group_rule" "app_to_public_entry" {
  type                     = "ingress"
  security_group_id        = aws_security_group.app_servers.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.public_entry.id
}

# this rule allows app_servers to communicate with database
resource "aws_security_group_rule" "app_to_database" {
  type                     = "egress"
  security_group_id        = aws_security_group.app_servers.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.database.id
}

# this rule allows app_servers to communicate with background_workers
resource "aws_security_group_rule" "app_to_workers" {
  type                     = "egress"
  security_group_id        = aws_security_group.app_servers.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.background_workers.id
}

# this rule allows app_servers out to internet
resource "aws_security_group_rule" "app_to_external" {
  type              = "egress"
  security_group_id = aws_security_group.app_servers.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# this rule allows background_workers to communicate with database
resource "aws_security_group_rule" "to_database_from_workers" {
  type                     = "ingress"
  security_group_id        = aws_security_group.database.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.background_workers.id
}

# this rule allows app_servers to communicate with database
resource "aws_security_group_rule" "from_app_to_database" {
  type                     = "ingress"
  security_group_id        = aws_security_group.database.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.app_servers.id
}

#placeholder for background_worker/storage rule