provider "aws" {
  region = var.aws_region
}

module "dynamodb" {
  source  = "./modules/dynamodb"
  kms_arn = module.kms_secrets_manager.kms_key_arn
}

module "lambda" {
  source           = "./modules/lambda"
  dynamodb_tb_name = module.dynamodb.table_name
  dynamodb_tb_arn  = module.dynamodb.table_arn
  kms_arn          = module.kms_secrets_manager.kms_key_arn
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  lambda_name       = module.lambda.lambda_function_name
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  lambda_arn        = module.lambda.lambda_function_arn
  environment       = var.environment
}

module "kms_secrets_manager" {
  source        = "./modules/kms_secrets_manager"
  api_key_token = module.api_gateway.api_key
}
