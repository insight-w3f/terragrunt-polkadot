terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-asg.git?ref=${local.vars.versions.asg}"
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
  security_groups = [
    dependency.network.outputs.api_security_group_id,
    dependency.network.outputs.consul_security_group_id,
    dependency.network.outputs.monitoring_security_group_id,
  ]
  subnet_ids = dependency.network.outputs.public_subnets
  vpc_id = dependency.network.outputs.vpc_id
  cluster_name = dependency.cluster.outputs.cluster_id
}
