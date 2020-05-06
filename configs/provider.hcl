locals {
  deployment_vars = read_terragrunt_config(("${get_parent_terragrunt_dir()}/deployment.hcl"))

  environment = local.deployment_vars.locals.environment
  region = local.deployment_vars.locals.region
  provider = local.deployment_vars.locals.provider

  remote_state = local.deployment_vars.locals.remote_state

  provider_config = lookup(local.provider_configs, local.provider)

  provider_configs = {
    aws = <<-EOP

%{ if local.remote_state.backend == "s3" || local.provider != "aws" }

provider "aws" {
  region = "${local.region}"
  skip_get_ec2_platforms     = true
  skip_metadata_api_check    = true
  skip_region_validation     = true
  skip_requesting_account_id = true
}

%{ endif }

EOP
    azure_provider = ""
    gcp_provider = ""
    do_provider = ""
    packet_provider = ""
    cloudflare_provider = ""
  }



}

//%{ if local.provider == "aws"}
//
//provider "aws" {
//region = "${local.region}"
//skip_get_ec2_platforms     = true
//skip_metadata_api_check    = true
//skip_region_validation     = true
//skip_requesting_account_id = true
//}
//
//data "aws_eks_cluster" "this" {
//name = var.cluster_id
//}
//
//data "aws_eks_cluster_auth" "this" {
//name = var.cluster_id
//}
//
//locals {
//token = data.aws_eks_cluster_auth.this.token
//host = data.aws_eks_cluster.this.endpoint
//cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
//}
//
//provider "kubernetes" {
//load_config_file       = false
//
//host                   = local.host
//token                  = local.token
//cluster_ca_certificate = local.cluster_ca_certificate
//}
//
//provider "helm" {
//service_account = "tiller"
//namespace       = "kube-system"
//install_tiller = true
//
//kubernetes {
//load_config_file       = false
//
//host                   = local.host
//token                  = local.token
//cluster_ca_certificate = local.cluster_ca_certificate
//}
//}
//
//%{ endif }