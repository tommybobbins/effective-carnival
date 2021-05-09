resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = file("json/assumerolepolicy.json")
}

resource "aws_iam_policy" "policy" {
  name        = "s3-policy"
  description = "Policy to allow access to S3"
  policy      = file("json/policys3bucket.json")
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "s3-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

#resource "aws_iam_role" "ssm_role" {
#  name               = "ssm_role"
#  assume_role_policy = file("json/ssmrolepolicy.json")
#}

#resource "aws_iam_role_policy_attachment" "ssm_attach" {
#  role       = aws_iam_role.ssm_role.name
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#}

#resource "aws_ssm_activation" "ssm_activate" {
#  name               = "ssm_activation"
#  description        = "SSM"
#  iam_role           = aws_iam_role.ssm_role.id
#  registration_limit = "5"
#  depends_on         = [aws_iam_role_policy_attachment.ssm_attach]
#}

