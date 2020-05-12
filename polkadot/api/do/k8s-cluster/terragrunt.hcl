terraform {
  source = "github.com/insight-w3f/terraform-polkadot-do-k8s-cluster.git?ref=${local.vars.versions.k8s-cluster}"
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
  security_group_id = dependency.network.outputs.sentry_security_group_id
  subnet_id = dependency.network.outputs.public_subnets[0]
}
