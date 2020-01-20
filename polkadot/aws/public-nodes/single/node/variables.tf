
variable "node_type" {
  type = string
  default = "prep"
}

variable "consul_enabled" {
  type = bool
  default = false
}

variable "prometheus_enabled" {
  type = bool
  default = false
}

variable "ssh_user" {
  type = string
  default = "ubuntu"
}

variable "name" {
  type = string
  default = "prep"
}

variable "monitoring" {
  type = bool
  default = true
}

variable "ebs_volume_size" {
  type = number
  default = 200
}

variable "root_volume_size" {
  type = number
  default = 25
}

variable "instance_type" {
  type = string
  default = "m5.large"
}

variable "volume_path" {
  type = string
  default = "/dev/xvdf"
}

variable "subnet_id" {
  type = string
  default = ""
}

variable "user_data" {
  type = string
  default = ""
}

variable "ami_id" {
  type = string
  default = ""
}

variable "public_key_path" {
  type = string
}

variable "private_key_path" {
  type = string
}

//variable "security_groups" {
//  type = list(string)
//  default = []
//}
// ^^^ EVIL

variable "vpc_security_group_ids" {
  type = list(string)
  default = null  # For conditional logic to trickle down to module
}

variable "corporate_ip" {
  type = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "playbook_file_path" {
  type = string
  default = ""
}
variable "roles_dir" {
  type = string
  default = "."
}

variable "playbook_vars" {
  type = map(string)
  default = {}
}

variable "network_name" {
  type = string
}

variable "eip_id" {
  type = string
  default = ""
}

variable "create_eip" {
  type = bool
  default = false
}