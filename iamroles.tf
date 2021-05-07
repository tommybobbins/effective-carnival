resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = "${file("json/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "s3-policy"
  description = "Policy to allow access to S3"
  policy      = "${file("json/policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "s3-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "s3_profile" {
  name  = "s3_profile"
  role = "${aws_iam_role.ec2_s3_access_role.name}"
}
