terraform {
  source = "github.com/insight-w3f/terraform-polkadot-azure-asg.git?ref=${local.vars.versions.asg}"
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
  k8s_resource_group = dependency.cluster.outputs.resource_group
  k8s_scale_set = dependency.cluster.outputs.scale_set
  public_subnet_id = dependency.network.outputs.public_subnets[0]
  private_subnet_id = dependency.network.outputs.private_subnets[0]
  network_security_group_id = dependency.network.outputs.public_network_security_group_id
  application_security_group_id = dependency.network.outputs.sentry_application_security_group_id[0]
  num_instances = 1
  chain = local.vars.network_name
  cluster_name = local.vars.id
}
