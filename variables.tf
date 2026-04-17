variable "key_name" {
  description = "SSH Key Pair ka naam"
  type        = string
  default     = "otms-key"
}

variable "secret_name" {
  description = "Secrets Manager mein secret ka naam"
  type        = string
  default     = "otms/ssh/private-key"
}
