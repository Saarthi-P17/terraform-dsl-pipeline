provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "otms-dev-state"
    region = var.aws_region
    key = "env/dev/application/network/vpc/terraform.tfstate"
  }
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}
