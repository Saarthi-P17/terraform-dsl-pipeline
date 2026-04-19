terraform {
  backend "s3" {
    bucket         = "otms-dev-state"
    key            = "env/dev/application/otms/ec2-instance/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = var.region
}

# 🔹 Get Subnet from Remote State
data "terraform_remote_state" "subnet" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 Get External ALB SG
data "terraform_remote_state" "alb_sg" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/otms/external-alb/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 EC2 Instance
resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = data.terraform_remote_state.subnet.outputs.private_subnet_1_id

  vpc_security_group_ids = [
    data.terraform_remote_state.alb_sg.outputs.security_group_id
  ]

  tags = {
    Name        = "${var.project}-${var.env}-app-server"
    Environment = var.env
    Project     = var.project
  }
}
