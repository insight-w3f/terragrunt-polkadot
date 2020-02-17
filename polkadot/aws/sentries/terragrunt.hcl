terraform {
  source = "github.com/robc-io/terraform-polkadot-sentry-nodes.git?ref=master"
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))
  network = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("network")}"
}

dependencies {
  paths = [local.network]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  security_group_name = "public-single"
  public_key_path = local.secrets.public_key_path
  private_key_path = local.secrets.private_key_path
}
