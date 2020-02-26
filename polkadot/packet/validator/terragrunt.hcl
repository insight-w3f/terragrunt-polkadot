terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))

  name = "public-single"
}

inputs = {
  name = local.name

  project_id = "polkadot"

  public_key = file(local.secrets["local_public_key"])
  private_key_path = local.secrets["local_private_key"]

  playbook_file_path = "${local.ansible}/main.yml"
  roles_dir = "${local.ansible}/roles"
}