variable "packet_auth_token" {
  description = ""
  type = string
}

variable "packet_project_name" {
  description = ""
  type = string
}

variable "packet_hostname" {
  description = ""
  type = string
}

provider "packet" {
  auth_token = var.packet_auth_token
  version = "~>2.3"
}

data "packet_project" "this" {
  name = var.packet_project_name
}

data "packet_device" "this" {
  project_id = data.packet_project.this.id
  hostname = var.packet_hostname
}

output "packet_validator_ip" {
  value = data.packet_device.this.access_public_ipv4
}
