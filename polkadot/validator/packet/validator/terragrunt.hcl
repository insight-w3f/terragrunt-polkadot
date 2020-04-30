terraform {
  source = "github.com/insight-w3f/terraform-polkadot-packet-node.git?ref=master"
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))
}

inputs = {
  name = local.global.packet_hostname
  project_name = local.global.packet_project_name
  public_key = file(local.secrets["public_key_path"])
}
