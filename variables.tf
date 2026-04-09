variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # N. Virginia
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/25"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "OTMS-vpc"
}
