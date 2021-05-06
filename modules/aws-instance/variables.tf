variable "instance_count" {
  description = "Number of EC2 instances to deploy"
  type        = number
}

variable "instance_type" {
  description = "Type of EC2 instance to use"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EC2 instances"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for EC2 instances"
  type        = list(string)
}

variable "tags" {
  description = "Tags for instances"
  type        = map(any)
  default     = {}
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
   default = "small"
   # var.HardDiskSize.values
}

