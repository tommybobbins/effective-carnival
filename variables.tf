# Variable declarations
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_count" {
  description = "Number of instances to provision."
  type        = number
  default     = 1
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "InstanceType" {
   description = "EC2 instance type"
   default = "t2.micro"
}

variable "hdd_size" {
  type = map
  default = {
    small = 50
    medium = 100
    large = 200
  }
}

variable "HardDiskSize" {
   description = "Hard drive size small (50GB), medium (100GB), large (200GB)"
   # var.HardDiskSize.values
   default = "small"
}

variable "Stage" {
   description = "Latest, Test, Beta or Prod. Maps to different Region for each case"
   default = "latest"
}

variable "stage_regions" {
  type = map
  default = {
    latest = "us-east-1"
    test = "us-east-1"
    beta = "us-east-1"
    prod = "us-east-1"
  }
}

