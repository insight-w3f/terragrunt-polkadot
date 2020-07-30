terraform {
  source = "github.com/insight-w3f/terraform-polkadot-aws-global.git?ref=${local.vars.versions.network}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

inputs = {
  region = local.vars.region
}
