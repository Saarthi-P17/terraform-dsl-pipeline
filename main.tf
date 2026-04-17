provider "aws" {
  region = us-east-1
}

terraform {
  backend "s3" {
    bucket = "otms-dev-state"
    region = "us-east-1"    # ✅ hardcoded
    key    = "env/dev/application/network/vpc/terraform.tfstate"
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
