provider "aws" {
  region = var.aws_region
}

# Get existing VPC by name
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = data.aws_vpc.existing_vpc.id
  cidr_block = var.public_subnet_cidr

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = data.aws_vpc.existing_vpc.id
  cidr_block = var.private_subnet_1_cidr

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = data.aws_vpc.existing_vpc.id
  cidr_block = var.private_subnet_2_cidr

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id     = data.aws_vpc.existing_vpc.id
  cidr_block = var.private_subnet_3_cidr

  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_subnet" "private_subnet_4" {
  vpc_id     = data.aws_vpc.existing_vpc.id
  cidr_block = var.private_subnet_4_cidr

  tags = {
    Name = "private-subnet-4"
  }
}
