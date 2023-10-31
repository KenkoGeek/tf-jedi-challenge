output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = module.api_gateway.api_gateway_url
}

output "api_key_secret_name" {
  description = "The name of the Secrets Manager secret storing the API key"
  value       = module.kms_secrets_manager.api_key_secret_name
}