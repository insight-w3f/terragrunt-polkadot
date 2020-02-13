variable "packet_auth_token" {
  description = ""
  type = string
}

variable "project_id" {
  description = ""
  type = string
}

variable "location" {
  description = ""
  type = string
  default = "ewr1"
}

variable "machine_type" {
  description = ""
  type = string
  default = "t1.small.x86"
}

variable "public_key" {
  description = ""
  type = string
}

variable "private_key_path" {
  description = ""
  type = string
}

variable "ssh_user" {
  type = string
  default = "root"
}

variable "playbook_file_path" {
  description = ""
  type = string
}

variable "roles_dir" {
  description = ""
  type = string
}

variable "playbook_vars" {
  description = ""
  type = map(string)
  default = {}
}

variable "node_count" {
  description = ""
  type = number
  default = 1
}

variable "name" {
  description = ""
  type = string
  default = "w3f"
}
