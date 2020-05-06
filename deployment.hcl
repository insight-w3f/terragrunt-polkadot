locals {
  stack = ""
  deployment_id = 0
  environment = "prod"
  namespace = "polkadot"
  region = "us-east-1"

  deployment_vars = yamldecode(file("${get_parent_terragrunt_dir()}/deployments/${local.stack}.${local.deployment_id}.yaml"))
}
