variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "my-terraform-key"
}
