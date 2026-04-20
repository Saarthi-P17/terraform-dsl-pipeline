output "instance_id" {
  value = aws_instance.backend_instance.id
}

output "private_ip" {
  value = aws_instance.backend_instance.private_ip
}

output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}
/*
output "subnet_id" {
  value = data.terraform_remote_state.subnets.outputs.private_subnet_2_id
}
*/
/*
output "vpc_id" {
  description = "VPC ID being used"
  value       = data.aws_vpc.selected.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = data.aws_subnets.available.ids
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.my_ec2.id
}
*/
output "primary_network_interface_id" {
  description = "Primary ENI of backend EC2"
  value       = aws_instance.backend_instance.primary_network_interface_id
}