provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "otms-dev-state7864582"
    key            = "env/dev/application/network/subnet/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

#  GET VPC FROM REMOTE STATE
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 AZs
locals {
  az_a = "us-east-1a"
  az_b = "us-east-1b"
}

# =========================
# 🌐 PUBLIC SUBNETS
# =========================

# Public Subnet - 1a
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = local.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1a"
    env = "dev"
    visibility = "public"
    az = "1a"
  }
}

# Public Subnet - 1b 
resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = local.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1a"
    env = "dev"
    visibility = "public"
    az = "1b"
  }
}

# =========================
# 🔒 PRIVATE SUBNETS
# =========================

# Private Subnet 1 (Frontend)
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = local.az_a

  tags = {
    Name = "private-subnet-1"
    env = "dev"
    visibility = "private"
    az = "1a"
    server = "frontend"
  }
}

# Private Subnet 2 (Backend)
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = local.az_a

  tags = {
    Name = "private-subnet-2"
    env = "dev"
    visibility = "private"
    az = "1a"
    server = "backend"
  }
}

# Private Subnet 3 (DB)
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = local.az_a

  tags = {
    Name = "private-subnet-3"
    env = "dev"
    visibility = "private"
    az = "1a"
    server = "db"
  }
}
