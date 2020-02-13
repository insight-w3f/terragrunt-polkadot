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
  az_num = 1
}
