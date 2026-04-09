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
variable "public_subnet_cidr" {
  default = "10.0.0.0/26"
}

variable "private_subnet_1_cidr" {
  default = "10.0.0.64/27"
}

variable "private_subnet_2_cidr" {
  default = "10.0.0.96/27"
}

variable "private_subnet_3_cidr" {
  default = "10.0.0.128/27"
}

variable "private_subnet_4_cidr" {
  default = "10.0.0.160/27"
}
