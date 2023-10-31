output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.jedi_lambda.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.jedi_lambda.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.jedi_lambda.invoke_arn
  description = "The invoke ARN of the Lambda function"
}