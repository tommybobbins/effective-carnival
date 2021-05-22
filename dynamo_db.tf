resource "aws_dynamodb_table" "user_accounts" {
  name         = "${var.project_name}-SFTP.${var.Stage}-user_accounts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user"

  attribute {
    name = "user"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

}

# This creates an example user in Dynamo DB so that it is clear what fields to populate.
resource "aws_dynamodb_table_item" "user_accounts_data" {
  table_name = aws_dynamodb_table.user_accounts.name
  hash_key   = aws_dynamodb_table.user_accounts.hash_key
  item       = file("json/dynamodb_usertemplate.json")
}
