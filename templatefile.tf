data "template_file" "init" {
  template = file("userdata.sh")
  vars = {
    project_name       = var.project_name,
    stage              = var.Stage
    bucket_config_name = aws_s3_bucket.bucketconfig.id
  }
}
