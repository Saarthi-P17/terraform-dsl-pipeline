terraform {
  backend "s3" {
    bucket         = "otms-dev-state7864582"
    key            = "env/dev/backend/notification-sg/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = var.region
}
/*
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
data "terraform_remote_state" "alb_sg" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/otms/external-alb/terraform.tfstate"
    region = "us-east-1"
  }
}
*/
# 🔹 Notification Security Group
resource "aws_security_group" "notification_sg" {
  name        = "${var.project}-${var.env}-notification-sg"
  description = "Notification Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id


  #  PORT 5000
  ingress {
    from_port                = 5000
    to_port                  = 5000
    protocol                 = "tcp"
    source_security_group_id = "env/dev/backend/security-group/bastion/terraform.tfstate"
  }

  # ✅ SSH (optional but as per your screenshot)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ✅ OUTBOUND ALL
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.env}-notification-sg"
    Environment = var.env
    Project     = var.project
  }
}
