terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v3.2.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))
  global_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))

  # Dependencies
  vpc = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("vpc")}"
  label = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("label")}"

  name = "consul"
}

dependencies {
  paths = [local.vpc, local.label]
}

dependency "vpc" {
  config_path = local.vpc
}

dependency "label" {
  config_path = local.label
}

inputs = {
  name = local.name

  create = local.global_vars["consul_enabled"]
  description = "All traffic"

  vpc_id = dependency.vpc.outputs.vpc_id
  tags = merge({Name: local.name}, dependency.label.outputs.tags)
}
