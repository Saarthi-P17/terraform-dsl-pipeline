provider "aws" {
  region = var.aws_region
}
terraform {
  backend "s3" {
    bucket = "otms-dev-state"
    region = var.aws_region
    key = "dev/terraform.tfstate"
  }
}
# Generate Private Key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS Key Pair using generated public key
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = {
    Name = var.key_name
  }
}

# Save Private Key locally
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.key_name}.pem"
}
