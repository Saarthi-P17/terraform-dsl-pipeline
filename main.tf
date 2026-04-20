provider "aws" {
  region = "us-east-1"
}

# ---------------------------
# Fetch existing EC2 backend
# ---------------------------
data "terraform_remote_state" "backend" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/backend/instances/terraform.tfstate"
    region = "us-east-1"
  }
}

# ---------------------------
# Create AMI from EC2
# ---------------------------
resource "aws_ami_from_instance" "backend_ami" {
  name               = "backend-ami-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  source_instance_id = data.terraform_remote_state.backend.outputs.instance_id
  description = "AMI created from backend EC2"

  tags = {
    Name = "backend-ami"
    env = var.env
    project = var.project

  }
}

variable "key_name" {
  default = "my-terraform-key"
}
# ---------------------------
# Launch Template using AMI
# ---------------------------
resource "aws_launch_template" "backend_lt" {
  name_prefix = "backend-lt-"

  image_id      = aws_ami_from_instance.backend_ami.id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = data.terraform_remote_state.backend.outputs.instance_id

  # Optional: user data
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Launched from Launch Template" > /home/ubuntu/lt.txt
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "backend-from-launch-template"
    }
  }

  tags = {
    Name = "backend-launch-template"
    env = var.env
    project = var.project
    server = "backend"
  }
}

# ---------------------------
# Outputs
# ---------------------------
output "ami_id" {
  value = aws_ami_from_instance.backend_ami.id
}

output "launch_template_id" {
  value = aws_launch_template.backend_lt.id
}