terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v2.15.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  global_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  label = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("label")}"
}

dependencies {
  paths = [local.label]
}

dependency "label" {
  config_path = local.label
}

inputs = {
  name = "${local.global_vars["namespace"]}-main"
  tags = dependency.label.outputs.tags

  enable_nat_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support = true

  azs = local.global_vars["azs"]

  cidr = "10.0.0.0/16"

  private_subnets = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets = ["10.0.192.0/24", "10.0.193.0/24", "10.0.194.0/24"]
}
