terraform {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
}

inputs = {
  tags = {
    NetworkName = local.global["network_name"]
    Owner = local.global["owner"]
    Terraform = true
    VpcType = "main"
  }

  environment = local.global["environment"]
  namespace = local.global["namespace"]
  network_name = local.global["network_name"]
}
