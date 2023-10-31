resource "aws_dynamodb_table" "jedi_table" {
  name           = "JediTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_arn
  }

  point_in_time_recovery {
    enabled = true
  }

}
