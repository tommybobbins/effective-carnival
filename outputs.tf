output "public_dns_name" {
  description = "Public DNS names of the load balancer for this project"
  value       = module.elb_http.this_elb_dns_name
}

output "disk_size" {
  description = "Disk size of the EC2 instance"
  value       = lookup(var.hdd_size, var.HardDiskSize)
}

output "aws_region" {
  description = "Region based on Stage"
  value       = lookup(var.stage_regions, var.Stage)
}

