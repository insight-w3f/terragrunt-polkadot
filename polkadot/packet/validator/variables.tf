variable "packet_auth_token" {}

variable "project_id" {
  type = string
}

variable "location" {
  default = "ewr1"
}

variable "machine_type" {
  default = "t1.small.x86"
}

variable "public_key" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "ssh_user" {
  type = string
  default = "root"
}

variable "playbook_file_path" {
  type = string
}

variable "roles_dir" {
  type = string
}

variable "playbook_vars" {
  type = map(string)
  default = {}
}

variable "node_count" {
  type = number
  default = 1
}

variable "name" {
  default = "w3f"
}
