output "hostname" {
  value = packet_device.validator.hostname
}

output "access_public_ipv4" {
  value = packet_device.validator.access_public_ipv4
}

output "access_private_ipv4" {
  value = packet_device.validator.access_private_ipv4
}

output "created" {
  value = packet_device.validator.created
}

output "public_ip" {
  value = packet_device.validator.network[0].address
}

output "tags" {
  value = packet_device.validator.tags
}

output "updated" {
  value = packet_device.validator.updated
}

output "plan" {
  value = packet_device.validator.plan
}

output "id" {
  value = packet_device.validator.id
}

