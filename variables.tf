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

variable "public_subnet_name" {
  description = "Public Subnet Name (for NAT)"
  type        = string
  default     = "public-subnet"
}
