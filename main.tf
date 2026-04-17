provider "aws" {
  region = us-east-1
}

terraform {
  backend "s3" {
    bucket = "otms-dev-state"
    region = "us-east-1"    # ✅ hardcoded
    key    = "env/dev/application/network/IGW/terraform.tfstate"
  }
}

# Get existing VPC
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "otms-igw"
  }
}
