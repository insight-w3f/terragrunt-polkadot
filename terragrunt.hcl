
locals {
  vars = read_terragrunt_config(find_in_parent_folders("${get_parent_terragrunt_dir()}/variables.hcl"))

  namespace = local.vars.locals.namespace
  environment = local.vars.locals.environment
  region = local.vars.locals.region
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    region = "us-east-1"
    key = "${local.namespace}/${local.environment}/${local.region}/${path_relative_to_include()}/terraform.tfstate"
    bucket = "terraform-states-${get_aws_account_id()}"
    dynamodb_table = "terraform-locks-${get_aws_account_id()}"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
local.vars.locals,
local.vars.locals.env_vars,
local.vars.locals.region_vars,
local.vars.locals.secrets,
)

generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents = read_terragrunt_config(find_in_parent_folders("${get_parent_terragrunt_dir()}/provider.hcl")).locals.provider_config
}
