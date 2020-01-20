terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v3.2.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))
  global_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))

  # Dependencies
  vpc = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("vpc")}"
  label = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("label")}"

  name = "prep-t1"
}

dependencies {
  paths = compact([local.vpc, local.label, local.global_vars["bastion_enabled"] ? "../sg-bastion" : "", local.global_vars["monitoring_enabled"] ? "../sg-monitoring" : "", local.global_vars["consul_enabled"] ? "../sg-consul" : ""])
}

dependency "vpc" {
  config_path = local.vpc
}

dependency "label" {
  config_path = local.label
}

dependency "bastion_sg" {
  config_path = "../sg-bastion"
  skip_outputs = !local.global_vars["bastion_enabled"]
}

dependency "monitoring_sg" {
  config_path = "../sg-monitoring"
  skip_outputs = !local.global_vars["monitoring_enabled"]
}

inputs = {
  name = "vault"
  description = "All traffic"

  create = local.global_vars["vault_enabled"]
  vpc_id = dependency.vpc.outputs.vpc_id
  tags = merge({Name: local.name}, dependency.label.outputs.tags)

//  TODO: Fix these ports
//  Long term: With logic to join all the groups that need joining and overview of who needs access to Vault
//  Sort term: Just opened ports to vpc but this is not secure
  ingress_with_cidr_blocks = concat(
  [{
    from_port = 8200
    to_port = 8200
    protocol = "tcp"
    description = "grpc traffic for when node starts producing blocks"
    cidr_blocks = "0.0.0.0/0"
  }, {
    from_port = 8201
    to_port = 8201
    protocol = "tcp"
    description = "Security group json rpc traffic"
    cidr_blocks = "0.0.0.0/0"
  }], local.global_vars["bastion_enabled"] ? [] :
  [{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Security group for ssh access from coporate ip"
    cidr_blocks = local.secrets["corporate_ip"] == "" ? "0.0.0.0/0" : "${local.secrets["corporate_ip"]}/32"
  }], )

  ingress_with_source_security_group_id = concat(local.global_vars["bastion_enabled"] ? [{
    rule = "ssh-tcp"
    source_security_group_id = dependency.bastion_sg.outputs.this_security_group_id
  }] : [], local.global_vars["monitoring_enabled"] ? [{
    from_port = 9100
    to_port = 9100
    protocol = "tcp"
    description = "Node exporter"
    source_security_group_id = dependency.monitoring_sg.outputs.this_security_group_id
  }, {
    from_port = 9333
    to_port = 9333
    protocol = "tcp"
    description = "Docker Prometheus Metrics under /metrics endpoint"
    source_security_group_id = dependency.monitoring_sg.outputs.this_security_group_id
  }] : [])

  ingress_cidr_blocks = local.global_vars["consul_enabled"] ? [dependency.vpc.outputs.vpc_cidr_block] : []
  ingress_rules = local.global_vars["consul_enabled"] ? ["consul-tcp", "consul-serf-wan-tcp", "consul-serf-wan-udp", "consul-serf-lan-tcp", "consul-serf-lan-udp", "consul-dns-tcp", "consul-dns-udp"] : []

  egress_with_cidr_blocks = [{
    from_port = 0
    to_port = 65535
    protocol = -1
    description = "Egress access open to all"
    cidr_blocks = "0.0.0.0/0"
  },]
}
