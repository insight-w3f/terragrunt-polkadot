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
  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.cluster, local.asg, local.network]
}

dependency "k8s" {
  config_path = local.cluster
}

dependency "asg" {
  config_path = local.asg
}

dependency "network" {
  config_path = local.network
}

generate "provider" {
  path = "kubernetes.tf"
  if_exists = "overwrite"
  contents =<<-EOF
data "google_client_config" "this" {}

provider "aws" {
  region = "${local.vars.remote_state_region}"
  skip_get_ec2_platforms     = true
  skip_metadata_api_check    = true
  skip_region_validation     = true
  skip_requesting_account_id = true
}

provider "helm" {
  version = "=1.1.1"
  kubernetes {
    host                   = "${dependency.k8s.outputs.endpoint}"
    cluster_ca_certificate = base64decode("${dependency.k8s.outputs.cluster_ca_cert}")
    token                  = data.google_client_config.this.access_token
    load_config_file       = false
  }
}

provider "kubernetes" {
    host                   = "${dependency.k8s.outputs.endpoint}"
    cluster_ca_certificate = base64decode("${dependency.k8s.outputs.cluster_ca_cert}")
    token                  = data.google_client_config.this.access_token
    load_config_file       = false
}
EOF
}

inputs = {
  cloud_platform = local.vars.provider
  google_project = local.vars.project
  google_service_account_key = local.vars.secrets.service_account_key
  lb_endpoint = dependency.asg.outputs.lb_endpoint
  user_email = local.vars.secrets.admin_user_email
  kubeconfig = base64encode(dependency.k8s.outputs.kube_config)
  deployment_domain_name = dependency.network.outputs.public_regional_domain
}
