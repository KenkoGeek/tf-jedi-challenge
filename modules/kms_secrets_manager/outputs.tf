output "kms_key_id" {
  description = "The unique identifier for the KMS key"
  value       = aws_kms_key.dynamodb_encryption_key.id
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = aws_kms_key.dynamodb_encryption_key.arn
}

output "kms_key_alias_name" {
  description = "The name of the KMS key alias"
  value       = aws_kms_alias.dynamodb_encryption_key_alias.name
}

output "kms_key_alias_arn" {
  description = "The ARN of the KMS key alias"
  value       = aws_kms_alias.dynamodb_encryption_key_alias.arn
}

output "api_key_secret_name" {
  description = "The name of the Secrets Manager secret storing the API key"
  value       = aws_secretsmanager_secret.api_key_secret.name
}

output "api_key_secret_arn" {
  description = "The ARN of the Secrets Manager secret storing the API key"
  value       = aws_secretsmanager_secret.api_key_secret.arn
}



