#terraform {
#  required_version = ">= 0.12, < 0.13"
#}

provider "aws" {
#  region = var.aws_region
  region = lookup(var.stage_regions, var.Stage)
  default_tags {
    tags = {
      ProjectName = "${var.project_name}-SFTP.${var.Stage}"
      Creator       = "tng@chegwin.org"
    }
  }
}

resource "aws_launch_configuration" "lc" {
  instance_type   = var.InstanceType
  image_id        = data.aws_ami.amazon_linux.id
  key_name        = aws_key_pair.webserver-key.key_name
  security_groups = [aws_security_group.instance.id]
  iam_instance_profile = "${aws_iam_instance_profile.s3_profile.name}"

#  user_data = file("userdata.sh")
  user_data = "${data.template_file.init.rendered}"
  root_block_device {
          volume_type = "gp2"
          volume_size = lookup(var.hdd_size, var.HardDiskSize)
  }
  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.lc.name
  # If using a private subnet, remember to enable NAT gateway in vpc.tf
  #vpc_zone_identifier  = module.vpc.private_subnets
  vpc_zone_identifier = module.vpc.public_subnets

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size         = var.min_instance_count
  max_size         = var.max_instance_count
  desired_capacity = var.desired_instance_count
}

resource "aws_lb" "lb" {

  name               = "${var.project_name}-${var.lb_name}"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {

  name = var.lb_name

  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

