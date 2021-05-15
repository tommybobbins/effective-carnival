
locals {
  config_prefix = "${var.project_name}-${var.bucket_seed}-${var.Stage}"
  data_prefix   = "${var.project_name}-${var.bucket_seed}-${var.Stage}"
}

resource "aws_s3_bucket" "bucketconfig" {
  bucket = "${local.config_prefix}-config"
  acl    = "private" # or can be "public-read"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "bucketdata" {
  bucket = "${local.data_prefix}-data"
  acl    = "private" # or can be "public-read"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#
## Upload an object
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucketconfig.id
  key    = "allconf.zip"
  acl    = "private" # or can be "public-read"
  source = "myfiles/allconf.zip"
  etag   = filemd5("myfiles/allconf.zip")
}


## Upload an object
resource "aws_s3_bucket_object" "caccounts" {
  bucket = aws_s3_bucket.bucketconfig.id
  key    = "caccounts.txt"
  acl    = "private" # or can be "public-read"
  source = "myfiles/caccounts.txt"
  etag   = filemd5("myfiles/caccounts.txt")
}

