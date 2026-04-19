terraform {
  backend "s3" {
    bucket         = "otms-dev-state"
    key            = "env/dev/application/otms/api1-sg/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

# 🔹 VPC Remote State
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔹 External ALB SG Remote State
data "terraform_remote_state" "external_alb" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/otms/external-alb/terraform.tfstate"
    region = "us-east-1"
  }
}

# 🔥 API1 SECURITY GROUP
resource "aws_security_group" "api1_sg" {
  name        = "api1"
  description = "api1 security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # 🔹 8082
  ingress {
    from_port                = 8082
    to_port                  = 8082
    protocol                 = "tcp"
    source_security_group_id = data.terraform_remote_state.external_alb.outputs.security_group_id
  }

  # 🔹 8081
  ingress {
    from_port                = 8081
    to_port                  = 8081
    protocol                 = "tcp"
    source_security_group_id = data.terraform_remote_state.external_alb.outputs.security_group_id
  }

  # 🔹 8080
  ingress {
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    source_security_group_id = data.terraform_remote_state.external_alb.outputs.security_group_id
  }

  # 🔹 5000
  ingress {
    from_port                = 5000
    to_port                  = 5000
    protocol                 = "tcp"
    source_security_group_id = data.terraform_remote_state.external_alb.outputs.security_group_id
  }

  # 🔹 SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 🔹 OUTBOUND ALL
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "api1"
  }
}
