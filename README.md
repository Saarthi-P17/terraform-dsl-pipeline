# terraform
terraform

created a bastion host and a bastion security group attached to it
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
# subnet block
data "terraform_remote_state" "subnets" {
  backend = "s3"

  config = {
    bucket = "otms-dev-state7864582"
    key    = "env/dev/application/network/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}
# bsation id
output "bastion_sg_id" {
  description = "Security Group ID for Bastion host"
  value       = aws_security_group.bastion_sg.id
}
