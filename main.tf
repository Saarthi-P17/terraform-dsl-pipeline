provider "aws" {
  region = var.region
}

# ✅ VPC remote state
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# ✅ External ALB SG remote state
data "terraform_remote_state" "external_alb_sg" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state"
    key    = "env/dev/application/otms/external-alb/terraform.tfstate"
    region = "us-east-1"
  }
}

# ✅ Notification Security Group
resource "aws_security_group" "notification_sg" {
  name        = "${var.project}-${var.env}-notification-sg"
  description = "Notification SG"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description     = "Allow 5000 from External ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.external_alb_sg.outputs.sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.env}-notification-sg"
  }
}
