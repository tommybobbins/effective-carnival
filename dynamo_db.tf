resource "aws_dynamodb_table" "user_accounts" {
  name         = "${var.project_name}-SFTP.${var.Stage}-user_accounts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user"
  range_key    = "rsa_key"

  attribute {
    name = "user"
    type = "S"
  }

  attribute {
    name = "rsa_key"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

}

