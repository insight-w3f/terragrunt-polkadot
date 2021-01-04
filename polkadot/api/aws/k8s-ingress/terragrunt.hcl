terraform {
  source = "github.com/shinyfoil/terraform-polkadot-k8s-api-ingress.git?ref=${local.vars.versions.k8s-ingress}"

  before_hook "update_kubeconfig" {
    commands     = ["apply", "plan", "destroy"]
    execute      = split(" ", "aws eks --region ${local.vars.run.region} update-kubeconfig --name ${local.vars.deployment_vars.cluster_name}")
  }
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

dependency "cluster" {
  config_path = local.cluster
}

dependency "asg" {
  config_path = local.asg
}

dependency "network" {
  config_path = local.network
}

inputs = {
  load_balancer_endpoint = dependency.asg.outputs.dns_name
  base_domain_name = dependency.network.outputs.public_regional_domain
  region = local.vars.run.region
}

generate "provider" {
  path = "kubernetes.tf"
  if_exists = "overwrite"
  contents =<<-EOF
data "aws_eks_cluster_auth" "this" {
  name = "${dependency.cluster.outputs.cluster_id}"
}

provider "aws" {
  region = "${local.vars.run.region}"
  skip_get_ec2_platforms     = true
  skip_metadata_api_check    = true
  skip_region_validation     = true
  skip_requesting_account_id = true
}

provider "helm" {
  version = "=1.1.1"
  kubernetes {
    host                   = "${dependency.cluster.outputs.cluster_endpoint}"
    cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_certificate_authority_data}")
    token                  = data.aws_eks_cluster_auth.this.token
    load_config_file       = false
  }
}

provider "kubernetes" {
    host                   = "${dependency.cluster.outputs.cluster_endpoint}"
    cluster_ca_certificate = base64decode("${dependency.cluster.outputs.cluster_certificate_authority_data}")
    token                  = data.aws_eks_cluster_auth.this.token
    load_config_file       = false
}
EOF
}

