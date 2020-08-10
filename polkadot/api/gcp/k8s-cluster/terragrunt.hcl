terraform {
  source = "github.com/insight-w3f/terraform-polkadot-gcp-k8s-cluster.git?ref=${local.vars.versions.k8s-cluster}"
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
  vpc_name = dependency.network.outputs.public_vpc_name
  cluster_name = local.vars.short_id
  kubernetes_subnet = dependency.network.outputs.kubernetes_subnet
}
