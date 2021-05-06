terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "random_string" "lb_id" {
  length  = 3
  special = false
}

provider "aws" {
#  region = var.aws_region
  region = lookup(var.stage_regions, var.Stage)
  default_tags {
    tags = {
      ProjectName = "${random_string.lb_id.result}-SFTP.${var.Stage}"
      Creator       = "tng@chegwin.org"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"
  name = "vpc-${random_string.lb_id.result}-SFTP.${var.Stage}"

  cidr            = var.vpc_cidr_block
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # Need nat gateway if ec2 instances are in private subnet
  enable_nat_gateway = false
  enable_vpn_gateway = false

}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name = "app-sg-${random_string.lb_id.result}-SFTP.${var.Stage}"
  description = "Security group for app-servers"
  vpc_id      = module.vpc.vpc_id

  #ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
  #ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
  # Add 22 rules
  ingress_rules = ["ssh-tcp","http-80-tcp"]
  # Allow all rules for all protocols - temporary, this needs to be public subnets
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name = "lb-sg-${random_string.lb_id.result}-SFTP.${var.Stage}"
  description = "Security group for load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Add 80 rules
  ingress_rules = ["http-80-tcp"]
  # Allow all rules for all protocols
  egress_rules = ["all-all"]

}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "2.4.0"

  # Ensure load balancer name is unique
  name = "lb-${random_string.lb_id.result}-SFTP-${var.Stage}"

  internal = false

  security_groups = [module.lb_security_group.this_security_group_id]
  subnets         = module.vpc.public_subnets

  number_of_instances = length(module.ec2_instances.instance_ids)
  instances           = module.ec2_instances.instance_ids

  listener = [{
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }]

  health_check = {
    target              = "HTTP:80/index.html"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
  }

}

module "ec2_instances" {
  source = "./modules/aws-instance"
#  name = "ec2-${random_string.lb_id.result}-SFTP.${var.Stage}"

  instance_count = var.instance_count
  instance_type  = "t2.micro"
  # Need NAT gateway enabling if private
  #subnet_ids = module.vpc.private_subnets[*]
  subnet_ids         = module.vpc.public_subnets[*]
  security_group_ids = [module.app_security_group.this_security_group_id]

  tags = {
    Hostname = "${random_string.lb_id.result}-SFTP.${var.Stage}-server1"
  }
}
