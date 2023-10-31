resource "aws_kms_key" "dynamodb_encryption_key" {
  description = "KMS key for encrypting DynamoDB table"
  enable_key_rotation = true
}

resource "aws_kms_alias" "dynamodb_encryption_key_alias" {
  name          = "alias/jedi_encryption_key"
  target_key_id = aws_kms_key.dynamodb_encryption_key.id
}

resource "aws_secretsmanager_secret" "api_key_secret" {
  name = "JediApiKeySecret"
  kms_key_id = aws_kms_key.dynamodb_encryption_key.arn
}

resource "aws_secretsmanager_secret_version" "api_key_secret_version" {
  secret_id     = aws_secretsmanager_secret.api_key_secret.id
  secret_string = var.api_key_token
}
