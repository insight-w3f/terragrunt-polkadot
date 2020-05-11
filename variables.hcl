locals {

  namespace = "polkadot"
  network_name = "kusama"
  environment = "dev"
  region = "us-east-1"

  deployment_name = "${local.stack}.${local.namespace}.${local.network_name}.${local.environment}.${local.region}"

  deployment = "${yamldecode(file("${get_parent_terragrunt_dir()}/deployments/${local.deployment_name}.yaml"))}"
  deployment_vars = "${local.deployment.locals.vars}"
  versions = "${yamldecode(file("${get_parent_terragrunt_dir()}/configs/versions.yaml"))[local.environment]}"
}
