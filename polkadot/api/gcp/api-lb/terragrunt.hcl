terraform {
  source = "github.com/insight-w3f/terraform-polkadot-gcp-sentry-api-lb.git?ref=${local.vars.versions.network}"
}

include {
  path = find_in_parent_folders()
}

locals {
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
