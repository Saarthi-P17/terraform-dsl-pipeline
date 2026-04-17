output "key_name" {
  description = "AWS Key Pair ka naam"
  value       = aws_key_pair.otms_key.key_name
}

output "secret_arn" {
  description = "Secrets Manager mein secret ka ARN"
  value       = aws_secretsmanager_secret.ssh_private_key.arn
}

output "secret_name" {
  description = "Secrets Manager mein secret ka naam"
  value       = aws_secretsmanager_secret.ssh_private_key.name
}
