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
//  iam = "${find_in_parent_folders("global")}/iam-asg"
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

//dependency "iam" {
//  config_path = local.iam
//}

inputs = {
  security_groups = [dependency.network.outputs.sentry_security_group_id]
  subnet_ids = dependency.network.outputs.public_subnets
  vpc_id = dependency.network.outputs.vpc_id
  cluster_name = dependency.cluster.outputs.cluster_id
//  iam_instance_profile = dependency.iam.outputs.iam_instance_profile
}
