locals {
  deployment = yamldecode(file("${get_parent_terragrunt_dir()}/deployment.yaml")).deployment_vars

  namespace = "polkadot"
  environment = local.deployment.locals.environment
  region = local.deployment.locals.region
  network_name = local.deployment.locals.network_name

  deployment_vars = local.deployment_vars

  secrets = local.deployment_vars.secrets

  environment = contains(keys(local.deployment), local.environment) ? local.environment : "dev"

  versions = yamldecode(file("${get_parent_terragrunt_dir()}/configs/versions.yaml"))[local.environment]

  secrets = yamldecode(file("${get_parent_terragrunt_dir()}/configs/secrets.yaml"))[local.environment]
  cluster_name = "${local.namespace}-${local.environment}"

  env_vars = {}
}
