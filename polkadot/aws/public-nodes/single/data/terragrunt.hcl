terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  label = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("label")}"
}

dependencies {
  paths = [local.label]
}

dependency "label" {
  config_path = local.label
}

inputs = {
  context = dependency.label.outputs.context

  namespace = local.global["namespace"]
  environment = local.global["environment"]
  network_name = local.global["network_name"]

  security_group_name = "public-single"
}
