# ---------------------------
# Provider & Backend
# ---------------------------
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "otms-dev-state7864582"
    key            = "env/dev/backend/instances/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

# ---------------------------
# 🔗 Remote State (VPC)
# ---------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# ---------------------------
# 🔗 Remote State (Subnets)
# ---------------------------

data "terraform_remote_state" "subnets" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

# ---------------------------
# Key Pair
# ---------------------------
data "aws_key_pair" "selected" {
  key_name = "my-terraform-key"
}



# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ restrict in prod
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "backend_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  #  Using private-subnet-2 from remote state
  subnet_id = data.terraform_remote_state.subnets.outputs.private_subnet_ids[1]
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  key_name = data.aws_key_pair.selected.key_name

  tags = {
    Name = "MyTerraformEC2"
    env = var.env
    project = var.project
  }
}





