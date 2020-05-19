terraform {
  source = "github.com/insight-w3f/terraform-polkadot-k8s-config.git?ref=${local.vars.versions.k8s-config}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  cluster = find_in_parent_folders("k8s-cluster")
  asg = find_in_parent_folders("asg")
}

dependencies {
  paths = [local.asg, local.cluster]
}

dependency "asg" {
  config_path = local.asg
}

dependency "cluster" {
  config_path = local.cluster
}

generate "provider" {
  path = "kubernetes.tf"
  if_exists = "overwrite"
  contents =<<-EOF
provider "helm" {
  version = "=1.1.1"
  kubernetes {
    host = "${dependency.cluster.outputs.endpoint}"
    username = "${dependency.cluster.outputs.username}"
    password = "${dependency.cluster.outputs.password}"
    client_certificate = base64decode("${dependency.cluster.outputs.cluster_client_certificate}")
    client_key = base64decode("${dependency.cluster.outputs.cluster_client_key}")
    cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_ca_cert}")
    load_config_file       = false
  }
}

provider "kubernetes" {
    host = "${dependency.cluster.outputs.endpoint}"
    username = "${dependency.cluster.outputs.username}"
    password = "${dependency.cluster.outputs.password}"
    client_certificate = base64decode("${dependency.cluster.outputs.cluster_client_certificate}")
    client_key = base64decode("${dependency.cluster.outputs.cluster_client_key}")
    cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_ca_cert}")
    load_config_file       = false
}

provider "aws" {
  region = "${local.vars.remote_state_region}"
  skip_get_ec2_platforms     = true
  skip_metadata_api_check    = true
  skip_region_validation     = true
  skip_requesting_account_id = true
}
EOF
}

inputs = {
  cloud_platform = local.vars.provider
  lb_endpoint = dependency.asg.outputs.lb_endpoint_ip
  user_email = local.vars.secrets.admin_user_email
  kubeconfig = base64encode(dependency.cluster.outputs.kube_config)
}
