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
  value       = var.project_name
}

output "config_bucket_name" {
  description = "Bucket containing the config"
  value       = aws_s3_bucket.bucketconfig.id
}

output "data_bucket_name" {
  description = "Bucket containing the data"
  value       = aws_s3_bucket.bucketdata.id
}

#output "vpc_resource_level_tags" {
#  value = provider.aws.tags
#}

output "nlb_all_tags" {
  value = aws_lb.lb.tags_all
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.user_accounts.arn
}
