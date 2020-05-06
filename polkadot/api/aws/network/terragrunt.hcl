terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-network.git?ref=${local.vars.versions.api.aws.network}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

inputs = {
  num_azs = 3
}
