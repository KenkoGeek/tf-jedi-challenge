output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = aws_api_gateway_deployment.jedi_deployment.invoke_url
}

output "api_key" {
  description = "The value of the API key"
  value       = aws_api_gateway_api_key.jedi_api_key.value
}
