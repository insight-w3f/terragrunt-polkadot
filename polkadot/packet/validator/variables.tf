########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = ""
}

##########
# Provider
##########
variable "packet_auth_token" {
  description = ""
  type = string
}

variable "project_name" {
  description = ""
  type = string
}

######
# Node
######
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


//variable "private_key_path" {
//  description = ""
//  type = string
//}
//
//variable "ssh_user" {
//  type = string
//  default = "root"
//}
//
//variable "playbook_file_path" {
//  description = ""
//  type = string
//}
//
//variable "roles_dir" {
//  description = ""
//  type = string
//}
//
//variable "playbook_vars" {
//  description = ""
//  type = map(string)
//  default = {}
//}
