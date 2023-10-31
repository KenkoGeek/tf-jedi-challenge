variable "lambda_name" {
    default = ""
    type = string
    description = "Lambda name"
}

variable "lambda_arn" {
    default = ""
    type = string
    description = "Lambda ARN"
}

variable "lambda_invoke_arn" {
    default = ""
    type = string
    description = "Lambda invoke ARN for APIGW"
}

variable "environment" {
    default = "prod"
    type = string
    description = "Deploymeny stage name"
}