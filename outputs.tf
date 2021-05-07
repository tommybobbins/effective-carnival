output "alb_dns_name" {
  value       = aws_lb.lb.dns_name
  description = "The domain name of the load balancer"
}
#output "ec2_ip" {
# value = ec2_instances.e
#}

#output "tags" {
#   value = instances.all_tags
#   description = "All tags"
#}

output "disk_size" {
  description = "Disk size of the EC2 instance"
  value       = lookup(var.hdd_size, var.HardDiskSize)
}

output "aws_region" {
  description = "Region based on Stage"
  value       = lookup(var.stage_regions, var.Stage)
}

output "project_name" {
  description = "Project identifier to be used as the seed for others"
  value =var.project_name
}

#output "all_tags" {
#  description = "All Tags"
#  value = aws.default_tags.tags[*]
#}