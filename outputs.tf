output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.sg.id
}

output "security_group_name" {
  description = "Security Group Name"
  value       = aws_security_group.sg.name
}

output "vpc_id" {
  description = "VPC ID used"
  value       = data.terraform_remote_state.vpc.outputs.vpc_id
}
