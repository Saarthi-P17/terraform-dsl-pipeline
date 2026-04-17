provider "aws" {
  region = var.aws_region
}
terraform {
  backend "s3" {
    bucket = "otms-dev-state"
    region = "us-east-1"    # ✅ hardcoded
    key    = "env/dev/application/network/NAT/terraform.tfstate"
  }
}

# Get existing VPC
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Get Public Subnet (where NAT will be placed)
data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = data.aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_eip.nat_eip]
}
