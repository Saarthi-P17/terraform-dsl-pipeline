# ---------------------------
# Bastion Security Group
# ---------------------------
terraform {
  backend "s3" {
    bucket         = "otms-dev-state7864582"
    key            = "env/dev/backend/security-group/bastion/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
// fetching vpc id
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "SSH from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # ⚠️ Replace with your IP (recommended)
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "bastion-sg"
    env     = var.env
    project = var.project
  }
}
data "terraform_remote_state" "subnets" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}
output "bastion_sg_id" {
  description = "Security Group ID for Bastion host"
  value       = aws_security_group.bastion_sg.id
}

variable "env" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "OTMS"
}

output "bastion_instance_details" {
  value = {
    instance_id = aws_instance.bastion.id
    subnet_id   = aws_instance.bastion.subnet_id
    sg_id       = aws_security_group.bastion_sg.id
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-04680790a315cd58d"
  instance_type = "t3.micro"

  #  Attach to PUBLIC subnet
  subnet_id = data.terraform_remote_state.subnets.outputs.public_subnet_ids[0]

  #  Attach Security Group
  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  key_name = "my-terraform-key"

  tags = {
    Name    = "bastion-host"
    env     = var.env
    project = var.project
  }
}
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
