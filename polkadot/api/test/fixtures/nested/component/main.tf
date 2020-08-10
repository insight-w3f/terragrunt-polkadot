//
//variable "id" {}
//output "id" {
//  value = var.id
//}
//
//variable "name" {}
//output "name" {
//  value = var.name
//}
//
//variable "remote_state_path" {}
//output "remote_state_path" {
//  value = var.remote_state_path
//}
//
//variable "deployment_id" {}
//output "deployment_id" {
//  value = var.deployment_id
//}
//
//variable "deployment_id_label_order" {}
//output "deployment_id_label_order" {
//  value = var.deployment_id_label_order
//}
//
//variable "deployment_vars" {}
//output "deployment_vars" {
//  value = var.deployment_vars
//}
//
variable "any" {
  type = any
}
output "any" {
  value = var.any
}

variable "private_key_path" {}
output "private_key_path" {
  value = var.private_key_path
}
