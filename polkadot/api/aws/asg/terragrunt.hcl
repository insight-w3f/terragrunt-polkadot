terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-asg.git?ref=${local.vars.versions.asg}"
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
  security_groups = [dependency.network.outputs.sentry_security_group_id]
  subnet_ids = dependency.network.outputs.public_subnets
  vpc_id = dependency.network.outputs.vpc_id
}
