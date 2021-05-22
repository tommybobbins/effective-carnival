data "template_file" "init" {
  template = file("userdata.sh")
  vars = {
    project_name       = var.project_name,
    stage              = var.Stage
    bucket_config_name = aws_s3_bucket.bucketconfig.id
    bucket_data_name   = aws_s3_bucket.bucketdata.id
    dynamo_db_table    = aws_dynamodb_table.user_accounts.arn
    aws_region         =  lookup(var.stage_regions, var.Stage)
  }
}
