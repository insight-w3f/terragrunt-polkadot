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
  data = "../data"

  name = "public-single"
}

dependencies {
  paths = [local.data]
}

dependency "data" {
  config_path = local.data
}

inputs = {
  name = local.name

  monitoring = true

  network_name = local.global.network_name

  instance_type = local.nodes["${local.name}"].instance_type
  ebs_volume_size = local.nodes["${local.name}"].ebs_volume_size
  root_volume_size = local.nodes["${local.name}"].root_volume_size

  volume_path = "/dev/xvdf"

  subnet_id = dependency.data.outputs.public_subnets[0]
  vpc_security_group_ids = dependency.data.outputs.vpc_security_group_ids

  create_eip = true

  public_key_path = local.secrets["local_public_key"]
  private_key_path = local.secrets["local_private_key"]

  playbook_file_path = "${local.ansible}/main.yml"
  roles_dir = "${local.ansible}/roles"

  playbook_vars = {
    project = local.global.owner

    ansible_ssh_common_args = "-o StrictHostKeyChecking=no -o ConnectTimeout=25 -o ControlMaster=no -o UserKnownHostsFile=/dev/null"
    polkadot_binary_url = "https://github.com/w3f/polkadot/releases/download/v0.6.2/polkadot"
    polkadot_binary_checksum: "sha256:b90443105acf9dbda67bada39541487bc05d935c57275aaf1daafbe5c8a42f3b"

    polkadot_network_id = "ksmcc2"
//    build_dir = "/tmp"
    node_exporter_enabled = true
    node_exporter_user = local.global.owner
    node_exporter_password = "hunter2"
//    node_exporter_binary_url = "{{ nodeExporterBinaryUrl }}"
//    node_exporter_binary_checksum = "{{ nodeExporterBinaryChecksum }}"
//    polkadot_restart_enabled = true
//    polkadot_restart_minute = "{{ polkadotRestartMinute }}"
//    polkadot_restart_hour = "{{ polkadotRestartHour }}"
//    polkadot_restart_day = "{{ polkadotRestartDay }}"
//    polkadot_restart_month = "{{ polkadotRestartMonth }}"
//    polkadot_restart_weekday = "{{ polkadotRestartWeekDay }}"
  }

  tags = dependency.data.outputs.tags
}
