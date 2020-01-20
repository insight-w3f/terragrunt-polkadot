output "instance_id" {
  value = module.ec2.instance_id
}

output "ip" {
  value = module.ec2.public_ip
}
