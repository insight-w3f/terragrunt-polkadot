variable "packet_auth_token" {
  description = ""
  type = string
}

provider "packet" {
  auth_token = var.packet_auth_token
  version = "~>2.3"
}
