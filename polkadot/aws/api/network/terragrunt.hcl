terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-network.git?ref=master"
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
}

inputs = {
  name = "${local.global["namespace"]}-main"
  az_num = 1
}
