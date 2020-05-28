terraform {
  source = "github.com/insight-w3f/terraform-polkadot-azure-k8s-cluster.git?ref=${local.vars.versions.k8s-cluster}"
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
  cluster_autoscale = false // required because PVC with ASG is currently broken
  # cluster_autoscale_min_workers = 3 // can be re-enabled once ASG is fixed
  # cluster_autoscale_max_workers = 100 // same as above
  k8s_version = "1.16.7"
  num_workers = 3 // has to be at least 3 workers
  vpc_id = dependency.network.outputs.vpc_id
  cluster_name = local.vars.id
}
