terraform {
  source = "github.com/insight-infrastructure/terraform-polkadot-aws-sentry-node.git?ref=master"
}

include {
  path = find_in_parent_folders()
}

locals {
  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))
  network = find_in_parent_folders("network")
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
