# Variable declarations
variable "aws_region" {
  description = "AWS region"
  type                        = string
  default     = "us-east-1"
}


variable "project_name" {
  description = "Project identifier to be used as the seed for others"
}

variable "Hostname" {
  description = "Hostname of the server which will be created"
  default           = "instance-bobbins1"
}

variable "bucket_seed" {
  description = "Unique Bucket seed"
  default     = "sftp-effective-carnival"
}

variable "desired_instance_count" {
  description = "Required number of instances to provision."
  type        = number
  default     = 1
}

variable "min_instance_count" {
  description = "Minimum number of instances to provision."
  type        = number
  default     = 1
}

variable "max_instance_count" {
  description = "Maximum number of instances to provision."
  type        = number
  default     = 2
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

variable "server_port" {
  description = "The backend port to target"
  type        = number
  default     = 22
}

variable "lb_name" {
  description = "The name of the LB"
  type        = string
  default     = "lb"
}

variable "instance_security_group_name" {
  description = "The name of the security group for the EC2 Instances"
  type        = string
  default     = "instance-sg"
}

variable "lb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
  default     = "lb-sg"
}

variable "InstanceType" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "hdd_size" {
  type = map(any)
  default = {
    small  = 50
    medium = 100
    large  = 200
  }
}

variable "HardDiskSize" {
  description = "Hard drive size small (50GB), medium (100GB), large (200GB)"
  # var.HardDiskSize.values
  default = "small"
}

variable "Stage" {
  description = "Latest, Test, Beta or Prod. Maps to different Region for each case"
  default     = "latest"
}

variable "stage_regions" {
  type = map(any)
  default = {
    latest = "us-east-1"
    test   = "us-east-1"
    beta   = "us-east-1"
    prod   = "us-east-1"
  }
}

