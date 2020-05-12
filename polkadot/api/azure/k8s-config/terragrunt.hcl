terraform {
  source = "github.com/insight-w3f/terraform-polkadot-azure-k8s-cluster.git?ref=${local.vars.versions.k8s-config}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
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
