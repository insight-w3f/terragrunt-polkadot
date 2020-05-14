locals {
  ######################
  # Deployment Variables
  ######################
  namespace = "polkadot"
  stack = "api"
  provider = "azure"
  network_name = "kusama"
  environment = "dev"
  region = "West Europe" # location

  remote_state_region = "us-east-1"

  ###################
  # Environment Logic
  ###################
  env_vars = {
    dev = {}
    prod = {}
  }[local.environment]

  # Imports
  versions = yamldecode(file("${get_parent_terragrunt_dir()}/versions.yaml"))[local.environment]
  secrets = yamldecode(file("${get_parent_terragrunt_dir()}/secrets.yaml"))[local.environment]

  ###################
  # Label Boilerplate
  ###################
  label_map = {
    namespace = local.namespace
    stack = local.stack
    provider = local.provider
    network_name = local.network_name
    environment = local.environment
    region = local.region
  }

  remote_state_path_label_order = ["namespace", "stack", "provider", "network_name", "environment", "region"]
  remote_state_path = join("/", [ for i in local.remote_state_path_label_order : lookup(local.label_map, i)])

  id_label_order = ["namespace", "stack", "network_name", "environment"]
  id = join("-", [ for i in local.id_label_order : lookup(local.label_map, i)])

  name_label_order = ["stack", "network_name"]
  name = join("", [ for i in local.name_label_order : title(lookup(local.label_map, i))])

  tags = { for t in local.remote_state_path_label_order : t => lookup(local.label_map, t) }
}
