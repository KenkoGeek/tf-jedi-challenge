data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_lambda_function" "jedi_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "jediLambdaFunction"
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.8"

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_tb_name
    }
  }

  tracing_config {
    mode = "Active"
  }
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_iam_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:BatchGet*",
          "dynamodb:Scan",
          "dynamodb:Query",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:CreateGrant*"
        ],
        Effect   = "Allow",
        Resource = [
          var.kms_arn,
          var.dynamodb_tb_arn,
          "arn:aws:logs:${data.aws_region.current.name}:${local.account_id}:log-group:/aws/lambda/${aws_lambda_function.jedi_lambda.function_name}:*"
        ]
      }
    ]
  })
}

