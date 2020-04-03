terraform {
  source = "github.com/insight-w3f/terraform-polkadot-gcp-k8s-cluster.git?ref=master"
}

include {
  path = find_in_parent_folders()
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
