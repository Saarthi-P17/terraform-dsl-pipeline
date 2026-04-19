output "instance_id" {
  value = aws_instance.app_server.id
}

output "private_ip" {
  value = aws_instance.app_server.private_ip
}

output "subnet_used" {
  value = data.terraform_remote_state.subnet.outputs.private_subnet_1_id
}
