locals {
  ######################
  # Deployment Variables
  ######################
  namespace = "polkadot"
  stack = "api"
  provider = "gcp"
  network_name = "kusama"
  environment = "dev"
  region = "us-east1"
  project = "polkadot-testing"

  deployment_map = {
    namespace = local.namespace
    stack = local.stack
    provider = local.provider
    network_name = local.network_name
    environment = local.environment
    region = local.region
  }

  remote_state_region = "us-east-1"
  consul_enabled = true
  monitoring_enabled = true
  prometheus_enabled = true
  create_public_regional_subdomain = true
  use_lb = true
  use_external_lb = false

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

  remote_state_path_order = ["namespace", "stack", "provider", "network_name", "environment", "region"]
  remote_state_path = join("/", [ for i in local.remote_state_path_order : lookup(local.deployment_map, i)])

  id_label_order = ["namespace", "stack", "network_name", "environment"]
  global_id = join("-", [ for i in local.id_label_order : lookup(local.deployment_map, i)])

  name_label_order = ["stack", "network_name", "environment"]
  global_name = join("", [ for i in local.name_label_order : lower(lookup(local.deployment_map, i))])

  short_id_label_order = ["stack", "network_name", "environment"]
  global_short_id = join("-", [ for i in local.short_id_label_order : lower(lookup(local.deployment_map, i))])

  tags = { for t in local.remote_state_path_order : t => lookup(local.deployment_map, t) }
}
