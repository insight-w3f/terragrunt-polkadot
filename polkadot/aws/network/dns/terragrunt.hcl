terraform {
  source = "github.com/insight-infrastructure/terraform-aws-icon-dns-setup.git?ref=master"
}

include {
  path = find_in_parent_folders()
}

locals {
  global_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))

  # Dependencies
  vpc = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("vpc")}"
}

dependencies {
  paths = [local.vpc]
}

dependency "vpc" {
  config_path = local.vpc
}

inputs = {
  environment = local.global_vars["environment"]
  vpc_ids = [dependency.vpc.outputs.vpc_id]

  internal_domain_name = local.global_vars["private_tld"]
  root_domain_name = local.global_vars["domain_name"]
}