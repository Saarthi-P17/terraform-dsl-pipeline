variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "otms-key"
}
