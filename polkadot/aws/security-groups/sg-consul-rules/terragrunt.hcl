terraform {
  source = "github.com/robc-io/terraform-aws-security-group.git?ref=v3.1.1"
}

include {
  path = find_in_parent_folders()
}

locals {
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))
  global_vars = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))

  # Dependencies
  vpc = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/${find_in_parent_folders("vpc")}"
}

dependencies {
  paths = compact([local.global_vars["bastion_enabled"] ? "../sg-bastion" : "", local.global_vars["consul_enabled"] ? "../sg-consul" : "", local.global_vars["monitoring_enabled"] ? "../sg-monitoring" : ""])
}

dependency "vpc" {
  config_path = local.vpc
}

dependency "monitoring_sg" {
  config_path = "../sg-monitoring"
  skip_outputs = !local.global_vars["monitoring_enabled"]
}

dependency "bastion_sg" {
  config_path = "../sg-bastion"
  skip_outputs = !local.global_vars["bastion_enabled"]
}

dependency "consul_sg" {
  config_path = "../sg-consul"
  skip_outputs = !local.global_vars["consul_enabled"]
}

inputs = {
  name = "consul"
  description = "All traffic"

  create = local.global_vars["consul_enabled"]
  security_group_id = local.global_vars["consul_enabled"] ? dependency.consul_sg.outputs.this_security_group_id : ""

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = local.global_vars["bastion_enabled"] ? [{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Security group for ssh access from coporate ip"
    cidr_blocks = local.secrets["corporate_ip"] == "" ? "0.0.0.0/0" : "${local.secrets["corporate_ip"]}/32"
  }] : []

  ingress_with_source_security_group_id = concat(
  local.global_vars["monitoring_enabled"] ? [{
    from_port = 9100
    to_port = 9100
    protocol = "tcp"
    description = "Node exporter"
    source_security_group_id = dependency.monitoring_sg.outputs.this_security_group_id
  },{
    from_port = 9428
    to_port = 9428
    protocol = "tcp"
    description = "Nordstrom/ssh_exporter"
    source_security_group_id = dependency.monitoring_sg.outputs.this_security_group_id
  }] : [], local.global_vars["bastion_enabled"] ?   [{
    rule = "ssh-tcp"
    source_security_group_id = dependency.bastion_sg.outputs.this_security_group_id
  }] : [], )

  egress_with_cidr_blocks = [{
    from_port = 0
    to_port = 65535
    protocol = -1
    description = "Egress access open to all"
    cidr_blocks = "0.0.0.0/0"
  },]

}
