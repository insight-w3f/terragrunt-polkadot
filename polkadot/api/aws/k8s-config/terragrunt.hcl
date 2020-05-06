terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-k8s-cluster.git?ref=${local.vars.versions.api.aws.k8s-config}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  version = yamldecode(file(find_in_parent_folders("versions.yaml")))[local.vars.environment].aws.api.network
}

dependencies {
  paths = ["../k8s-cluster"]
}

dependency "k8s" {
  config_path = "../k8s-cluster"
}

inputs = {
  cluster_id = dependency.k8s.outputs.cluster_id
}
