provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "otms-dev-state"
    region = "us-east-1"
    key    = "env/dev/application/network/sshkey/terraform.tfstate"
  }
}

# Step 1: RSA Private Key Generate karo
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096          # ✅ Fix 1: 2048 → 4096
}

# Step 2: AWS mein Key Pair banao
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = {
    Name = var.key_name
  }
}

# Step 3: Secrets Manager mein Secret banao
resource "aws_secretsmanager_secret" "ssh_private_key" {
  name        = var.secret_name
  description = "OTMS SSH Private Key"

  tags = {
    Name = var.secret_name
  }
}

# Step 4: Private Key us secret mein store karo
resource "aws_secretsmanager_secret_version" "ssh_private_key_value" {
  secret_id     = aws_secretsmanager_secret.ssh_private_key.id
  secret_string = tls_private_key.ssh_key.private_key_pem  # ✅ Fix 2: local file hataya, Secrets Manager add kiya
}
