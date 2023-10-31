resource "aws_api_gateway_usage_plan" "jedi_usage_plan" {
  name = "JediUsagePlan"
  api_stages {
    api_id = aws_api_gateway_rest_api.jedi_api.id
    stage  = aws_api_gateway_deployment.jedi_deployment.stage_name
  }
}

resource "aws_api_gateway_api_key" "jedi_api_key" {
  name = "JediApiKey"
  description = "API key for accessing Jedi API"
  enabled = true
}

resource "aws_api_gateway_usage_plan_key" "jedi_usage_plan_key" {
  key_id   = aws_api_gateway_api_key.jedi_api_key.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.jedi_usage_plan.id
}

resource "aws_api_gateway_rest_api" "jedi_api" {
  name        = "JediAPI"
  description = "API to retrieve Jedi information"
}

resource "aws_api_gateway_resource" "jedi_resource" {
  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  parent_id   = aws_api_gateway_rest_api.jedi_api.root_resource_id
  path_part   = "jedi"
}

resource "aws_api_gateway_method" "jedi_method" {
  rest_api_id   = aws_api_gateway_rest_api.jedi_api.id
  resource_id   = aws_api_gateway_resource.jedi_resource.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  resource_id = aws_api_gateway_resource.jedi_resource.id
  http_method = aws_api_gateway_method.jedi_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "jedi_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.jedi_api.id
  resource_id   = aws_api_gateway_resource.jedi_resource.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  resource_id = aws_api_gateway_resource.jedi_resource.id
  http_method = aws_api_gateway_method.jedi_post_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

#tfsec:ignore:aws-lambda-restrict-source-arn
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "jedi_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration, aws_api_gateway_integration.lambda_post_integration]

  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  stage_name  = var.environment
}

resource "aws_api_gateway_method_settings" "jedi_apigw" {
  rest_api_id = aws_api_gateway_rest_api.jedi_api.id
  stage_name  = aws_api_gateway_deployment.jedi_deployment.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}