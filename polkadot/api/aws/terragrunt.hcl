locals {
  vars = read_terragrunt_config(find_in_parent_folders("${get_parent_terragrunt_dir()}/common.hcl")).locals

//  run = yamldecode(file(find_in_parent_folders("run.yaml")))
//  settings = yamldecode(file(find_in_parent_folders("settings.yaml")))
//
//  # Imports
//  versions = yamldecode(file("versions.yaml"))[local.run.environment]
//  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))
//  deployment_id_order = local.settings.deployment_id_order
//  deployment_id = join(".", [ for i in local.deployment_id_order : lookup(local.run, i)])
//  deployment_vars = yamldecode(file("${find_in_parent_folders("deployments")}/${local.deployment_id}.yaml"))
//
//  # Labels
//  id_label_order = local.settings.id_label_order
//  id = join("-", [ for i in local.id_label_order : lookup(local.run, i)])
//  name_label_order = local.settings.name_label_order
//  name = join("", [ for i in local.name_label_order : title(lookup(local.run, i))])
//  tags = { for t in local.remote_state_path_order : t => lookup(local.run, t) }
//
//  # Remote State
//  remote_state_path_order = local.settings.remote_state_path_order
//  remote_state_path = join("/", [ for i in local.remote_state_path_order : lookup(local.run, i)])
}

inputs = merge(
local.vars,
local.vars.run,
local.vars.secrets,
local.vars.deployment_vars,
)

generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents =<<-EOF
provider "aws" {
  region = "${local.vars.run.region}"
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

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    region = "us-east-1"
    key = "${local.vars.remote_state_path}/${path_relative_to_include()}/terraform.tfstate"
    bucket = "terraform-states-${get_aws_account_id()}"
    dynamodb_table = "terraform-locks-${get_aws_account_id()}"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
