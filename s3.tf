#
#resource "aws_s3_bucket" "b1" {
#  bucket = "s3-terraform-bucket-lab"
#  acl    = "private"   # or can be "public-read"
#  tags = {
#    Name        = "My bucket"
#    Environment = "Dev"
#  }
#}
#
## Upload an object
#resource "aws_s3_bucket_object" "object" {
#  bucket = aws_s3_bucket.b1.id
#  key    = "profile"
#  acl    = "private"  # or can be "public-read"
#  source = "myfiles/yourfile.txt"
#  etag = filemd5("myfiles/yourfile.txt")
#
#}
