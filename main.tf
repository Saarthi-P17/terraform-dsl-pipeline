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

# ✅ GET VPC FROM REMOTE STATE
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 Common AZ (same for all)
locals {
  az = "us-east-1a"
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = var.public_subnet_cidr
  availability_zone = local.az

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = local.az

  tags = {
    Name = "private-subnet-1"
  }
}

# Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = local.az

  tags = {
    Name = "private-subnet-2"
  }
}

# Private Subnet 3
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = local.az

  tags = {
    Name = "private-subnet-3"
  }
}
