terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-asg.git?ref=${local.vars.versions.api.aws.asg}"
}

include {
  path = find_in_parent_folders()
}

skip = !local.vars.aws_enable

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
  public_key = local.vars.public_key
  security_group_id = dependency.network.outputs.sentry_security_group_id
  subnet_id = dependency.network.outputs.public_subnets[0]
}
