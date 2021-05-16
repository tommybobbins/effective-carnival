##aws_iam_instance_profile.ec2_access_role.name
##A managed resource "aws_iam_role" "ec2_access_role" has not been declared in the root module.
resource "aws_iam_instance_profile" "ec2_access_role" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_instance_role.name
}

resource "aws_iam_role" "ec2_instance_role" {
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_assume_role_policy.json
  name               = "${var.project_name}-${var.Hostname}-Ec2InstanceRole"
}



#// Allow EC2 instance to register as ECS cluster member, fetch ECR images, write logs to CloudWatch
data "aws_iam_policy_document" "ec2_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#
resource "aws_iam_role_policy_attachment" "ec2_instance_role" {
  role       = aws_iam_role.ec2_instance_role.name
#  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core_role" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# More restrictive S3 policy instead of AmazonS3FullAccess
resource "aws_iam_policy" "s3_policy" {
  name        = "s3_policy"
  description = "Policy to allow access to S3"
  policy      = file("json/policys3bucket.json")
}


#data "aws_iam_policy_document" "allow_create_log_groups" {
#  statement {
#    actions   = ["logs:CreateLogGroup"]
#    resources = ["*"]
#  }
#}
#
#resource "aws_iam_role_policy" "allow_create_log_groups" {
#  policy = data.aws_iam_policy_document.allow_create_log_groups.json
#  role   = aws_iam_role.ecs_task_role.id
#}
