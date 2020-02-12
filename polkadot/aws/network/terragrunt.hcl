terraform {
  source = "github.com/robc-io/terraform-aws-polkadot-network.git?ref=master"
}

include {
  path = find_in_parent_folders()
}

locals {
  global_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
}

inputs = {
  name = "${local.global_vars["namespace"]}-main"
  azs = local.global_vars["azs"]
  cidr = "10.0.0.0/16"
  private_subnets = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets = ["10.0.192.0/24", "10.0.193.0/24", "10.0.194.0/24"]
}
