resource "aws_launch_configuration" "lc" {
  instance_type        = var.InstanceType
  image_id             = data.aws_ami.amazon_linux.id
  key_name             = aws_key_pair.webserver-key.key_name
  security_groups      = [aws_security_group.instance.id]
  iam_instance_profile = aws_iam_instance_profile.s3_profile.name

  #  user_data = file("userdata.sh")
  user_data = data.template_file.init.rendered
  root_block_device {
    volume_type = "gp2"
    volume_size = lookup(var.hdd_size, var.HardDiskSize)
  }
  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_s3_bucket.bucketdata,
  ]
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.lc.name
  # If using a private subnet, remember to enable NAT gateway in vpc.tf
  #vpc_zone_identifier  = module.vpc.private_subnets
  vpc_zone_identifier = module.vpc.public_subnets

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  min_size         = var.min_instance_count
  max_size         = var.max_instance_count
  desired_capacity = var.desired_instance_count
}


resource "aws_autoscaling_policy" "web_policy_up" {
  name                   = "web_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "10"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "90"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_up.arn]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "web_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name          = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_down.arn]
}
