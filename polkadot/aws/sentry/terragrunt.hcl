terraform {
  source = "github.com/insight-infrastructure/terraform-polkadot-aws-sentry-node.git?ref=master"
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
  public_key_path = local.secrets.public_key_path
  security_group_id = dependency.network.outputs.sentry_security_group_id
  subnet_id = dependency.network.outputs.public_subnets[0]
}
