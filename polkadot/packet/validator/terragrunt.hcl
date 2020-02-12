terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))
  nodes = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("nodes.yaml")}"))

  # Dependencies
  ansible = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("ansible")}"
//  data = "../data"

  name = "public-single"
}

//dependencies {
//  paths = [local.data]
//}
//
//dependency "data" {
//  config_path = local.data
//}

inputs = {
  name = local.name

  project_id = "stuff"

  public_key = file(local.secrets["local_public_key"])
  private_key_path = local.secrets["local_private_key"]

  playbook_file_path = "${local.ansible}/main.yml"
  roles_dir = "${local.ansible}/roles"

  playbook_vars = {
    project = local.global.owner

    ansible_user="root"
    vpnpeer_address="10.0.0.1"
    vpnpeer_cidr_suffix=24
    telemetryUrl="wss://mi.private.telemetry.backend/"
    loggingFilter="sync=trace,afg=trace,babe=debug"


    ansible_ssh_common_args = "-o StrictHostKeyChecking=no -o ConnectTimeout=25 -o ControlMaster=no -o UserKnownHostsFile=/dev/null"
    polkadot_binary_url = "https://github.com/w3f/polkadot/releases/download/v0.6.2/polkadot"
    polkadot_binary_checksum: "sha256:b90443105acf9dbda67bada39541487bc05d935c57275aaf1daafbe5c8a42f3b"

    polkadot_network_id = "ksmcc2"
//    build_dir = "/tmp"
    node_exporter_enabled = true
    node_exporter_user = local.global.owner
    node_exporter_password = "hunter2"
  }

//  tags = dependency.data.outputs.tags
}
