variable "dynamodb_tb_name" {
    default = ""
    type = string
    description = "DynamoDB name to store the data"
}

variable "dynamodb_tb_arn" {
    default = ""
    type = string
    description = "DynamoDB ARN for role policy"
}

variable "kms_arn" {
    default = ""
    type = string
    description = "CMK ARN for role policy"
}