//output "ip_address" {
//  value = packet_device.validator.*.network.0.address
//}

output "ip_address" {
  value = packet_device.validator.network[0].address
}
