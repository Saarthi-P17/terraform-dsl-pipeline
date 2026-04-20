output "key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "private_key_file" {
  value = local_file.private_key_pem.filename
}
