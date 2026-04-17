provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "otms-dev-state"
    key            = "env/dev/application/network/route-table/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

# ✅ REMOTE STATES
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "subnet" {
  backend = "s3"
  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "igw" {
  backend = "s3"
  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/IGW/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "nat" {
  backend = "s3"
  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/NAT/terraform.tfstate"
    region = "us-east-1"
  }
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.terraform_remote_state.igw.outputs.igw_id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = data.terraform_remote_state.subnet.outputs.public_subnet_id
  route_table_id = aws_route_table.public_rt.id
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "private_rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = data.terraform_remote_state.nat.outputs.nat_gateway_id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = data.terraform_remote_state.subnet.outputs.private_subnet_ids[0]
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = data.terraform_remote_state.subnet.outputs.private_subnet_ids[1]
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_3" {
  subnet_id      = data.terraform_remote_state.subnet.outputs.private_subnet_ids[2]
  route_table_id = aws_route_table.private_rt.id
}
