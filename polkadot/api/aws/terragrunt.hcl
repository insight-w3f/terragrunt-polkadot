locals {
  vars = read_terragrunt_config(find_in_parent_folders("${get_parent_terragrunt_dir()}/variables.hcl"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    region = "us-east-1"
    key = "${local.vars.locals.remote_state_path}/${path_relative_to_include()}/terraform.tfstate"
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
local.vars.locals.secrets,
)

generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents =<<-EOF
provider "aws" {
  region = "${local.vars.locals.region}"
  skip_get_ec2_platforms     = true
  skip_metadata_api_check    = true
  skip_region_validation     = true
  skip_requesting_account_id = true
}

provider "cloudflare" {
  version = "~> 2.0"
}
EOF
}
