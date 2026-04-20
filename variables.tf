variable "vpc_name" {
  description = "Existing VPC Name"
  type        = string
  default     = "OTMS-vpc"
}

# =========================
# 🌐 PUBLIC SUBNET CIDRs
# =========================

# Bastion / Public 1a
variable "public_subnet_cidr" {
  default = "10.0.0.0/28"
}

# Public 1b ✅ NEW
variable "public_subnet_2_cidr" {
  default = "10.0.0.64/28"
}

# =========================
# 🔒 PRIVATE SUBNET CIDRs
# =========================

# Frontend
variable "private_subnet_1_cidr" {
  default = "10.0.0.16/28"
}

# Backend
variable "private_subnet_2_cidr" {
  default = "10.0.0.32/28"
}

# DB
variable "private_subnet_3_cidr" {
  default = "10.0.0.48/28"
}
