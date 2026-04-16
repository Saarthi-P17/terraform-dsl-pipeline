provider "aws" {
  region = var.aws_region
}
terraform {
  backend "s3" {
    bucket = "otms-dev-state"
    region = var.aws_region
    key = "dev/terraform.tfstate"
  }
}
# Get existing VPC
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Get IGW
data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

# Get NAT Gateway
data "aws_nat_gateway" "nat" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

# Get Subnets
data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name]
  }
}

data "aws_subnet" "private1" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-1"]
  }
}

data "aws_subnet" "private2" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-2"]
  }
}

data "aws_subnet" "private3" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-3"]
  }
}
/*
data "aws_subnet" "private4" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-4"]
  }
}
*/

# ---------------- PUBLIC ROUTE TABLE ----------------
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = data.aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------- PRIVATE ROUTE TABLE ----------------
resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Associate Private Subnets
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = data.aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = data.aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_3" {
  subnet_id      = data.aws_subnet.private3.id
  route_table_id = aws_route_table.private_rt.id
}

/*
resource "aws_route_table_association" "private_assoc_4" {
  subnet_id      = data.aws_subnet.private4.id
  route_table_id = aws_route_table.private_rt.id
}
*/