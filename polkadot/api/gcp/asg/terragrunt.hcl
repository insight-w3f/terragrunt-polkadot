terraform {
  source = "github.com/insight-w3f/terraform-polkadot-gcp-asg.git?ref=${local.vars.versions.asg}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
  cluster = find_in_parent_folders("k8s-cluster")
}

dependencies {
  paths = [local.network, local.cluster]
}

dependency "network" {
  config_path = local.network
}

dependency "cluster" {
  config_path = local.cluster
}

inputs = {
  public_subnet_id = dependency.network.outputs.public_subnets[1]
  private_subnet_id = dependency.network.outputs.private_subnets[1]
  node_name = local.vars.short_id
  security_group_id = dependency.network.outputs.sentry_security_group_id[0]
  vpc_id = dependency.network.outputs.public_vpc_id
  cluster_name = dependency.cluster.outputs.cluster_name

  # relay_node_ip = TODO
  # relay_node_p2p_address = TODO
}
