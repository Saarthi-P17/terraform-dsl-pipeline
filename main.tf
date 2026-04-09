provider "aws" {
  region = var.aws_region
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

data "aws_subnet" "private4" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-4"]
  }
}
