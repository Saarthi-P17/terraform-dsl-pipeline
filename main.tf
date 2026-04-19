terraform {
  backend "s3" {
    bucket         = "otms-dev-state"
    key            = "env/dev/application/otms/ec2-instance/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

# 🔹 Subnet (must be us-east-1a)
data "terraform_remote_state" "subnet" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 Security Group
data "terraform_remote_state" "alb_sg" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/otms/external-alb/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "frontend_instance" {
  ami           = "ami-0b73ce37f347c345b"
  instance_type = "t3.small"

  # 🔥 THIS decides AZ
  subnet_id = data.terraform_remote_state.subnet.outputs.private_subnet_1_id

  vpc_security_group_ids = [
    data.terraform_remote_state.alb_sg.outputs.security_group_id
  ]

  associate_public_ip_address = false

  tags = {
    Name = "frontend-us-east-1a"
  }
}
