terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
}

inputs = {
  any = local.vars
}
