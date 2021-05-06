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

#output "tags" {
#  description = "Tags"
#  value = module.vpc.this[0].all_tags
#}

#output "tags" {
#description = "List of tags of the APP and DB instances"
#value       = [module.ec2_instances.tags.Name,
#               module.ec2_instances.tags.Creator]
#}


#output "creator" {
#  description = "Creator"
#  value = ${lookup(aws.default_tags.tags,"Creator")}"
#}

#output "Hostname" {
#  description = "Public DNS name of the NLB"
#  value       = module.elb_http.this_elb_dns_name
#}
