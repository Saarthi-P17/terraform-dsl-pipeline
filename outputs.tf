output "instance_id" {
  value = aws_instance.frontend_instance.id
}

output "private_ip" {
  value = aws_instance.frontend_instance.private_ip
}
