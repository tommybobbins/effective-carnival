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

resource "aws_lb" "lb" {

  name               = "${var.project_name}-${var.lb_name}"
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets
  #security_groups    = [aws_security_group.lb.id]
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 22
  protocol          = "TCP"

  # By default, forward
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {
  name = var.lb_name
  port     = var.server_port
  protocol = "TCP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    interval            = 30
  }
}

#resource "aws_lb_listener_rule" "asg" {
#  listener_arn = aws_lb_listener.http.arn
#  priority     = 100
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.asg.arn
#  }
#}

