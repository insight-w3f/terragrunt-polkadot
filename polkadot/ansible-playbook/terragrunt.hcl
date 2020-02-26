terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))

  # Dependencies
  ansible = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("ansible")}"
}

//dependencies {
//  paths = [local.data]
//}
//
//dependency "data" {
//  config_path = local.data
//}

inputs = {
  packet_project_name = "polkadot"
  packet_hostname = local.global.packet_hostname

  playbook_file_path = "${local.ansible}/main.yml"
  private_key_path = local.secrets["private_key_path"]
}
