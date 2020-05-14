terraform {
  source = "github.com/insight-w3f/terraform-polkadot-gcp-sentry-node.git?ref=${local.vars.versions.asg}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
  api_lb = find_in_parent_folders("api-lb")
}

dependencies {
  paths = [local.network, local.api_lb]
}

dependency "network" {
  config_path = local.network
}

dependency "api_lb" {
  config_path = local.api_lb
}

inputs = {
  security_group_id = dependency.network.outputs.sentry_security_group_id
  subnet_id = dependency.network.outputs.public_subnets[0]
}
