terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-node.git?ref=${local.vars.versions.truth}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.network, local.cluster]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  security_groups = [
    dependency.network.outputs.api_security_group_id,
    dependency.network.outputs.consul_security_group_id,
    dependency.network.outputs.monitoring_security_group_id,
  ]
  subnet_id = dependency.network.outputs.public_subnets[0]
  vpc_id = dependency.network.outputs.vpc_id
  security_group_id = dependency.network.outputs.api_security_group_id
  node_purpose = "truth"
}
