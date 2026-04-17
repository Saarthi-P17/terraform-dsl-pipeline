variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Existing VPC Name"
  type        = string
  default     = "OTMS-vpc"
}

# Subnet CIDRs
// bastion
variable "public_subnet_cidr" {
  default = "10.0.0.0/28"
}
//frontend
variable "private_subnet_1_cidr" {
  default = "10.0.0.16/28"
}
// backend
variable "private_subnet_2_cidr" {
  default = "10.0.0.32/28"
}
// db
variable "private_subnet_3_cidr" {
  default = "10.0.0.48/28"
}


