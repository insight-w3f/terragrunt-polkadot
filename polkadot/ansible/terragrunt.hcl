terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))
  nodes = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("nodes.yaml")}"))

  # Dependencies
  ansible = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("ansible")}"

  name = "public-single"
}

//dependencies {
//  paths = [local.data]
//}
//
//dependency "data" {
//  config_path = local.data
//}

inputs = {
  name = local.name

  project_id = "polkadot"

  private_key_path = local.secrets["local_private_key"]

  playbook_file_path = "${local.ansible}/main.yml"
  roles_dir = "${local.ansible}/roles"


}
