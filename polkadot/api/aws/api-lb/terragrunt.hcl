terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-api-lb.git?ref=${local.vars.versions.api.aws.api-lb}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.network]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = dependency.network.outputs.public_subnets
  security_group_id = dependency.network.outputs.sentry_security_group_id
}
