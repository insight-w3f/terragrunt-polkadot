output "aws_instance_ids" {
  value = data.aws_instances.sentries.ids
}

output "aws_public_ips" {
  value = data.aws_instances.sentries.public_ips
}