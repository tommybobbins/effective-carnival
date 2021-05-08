module "vpc" {
  name    = "${var.project_name}-${var.Stage}"
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  cidr            = var.vpc_cidr_block
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # Need nat gateway if ec2 instances are in private subnet
  #enable_nat_gateway = true
  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_ipv6                     = true
  #assign_ipv6_address_on_creation = true

  #private_subnet_assign_ipv6_address_on_creation = false
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_default_security_group" "default" {
  vpc_id   = module.vpc.vpc_id
#  description = "Default VPC group to allow ingress on SSH"

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = var.server_port
    to_port   = var.server_port
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
