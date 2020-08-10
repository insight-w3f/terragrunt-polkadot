terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks.git?ref=${local.vars.versions.k8s-cluster}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.network]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnets = dependency.network.outputs.public_subnets
  security_group_id = dependency.network.outputs.k8s_security_group_id

  worker_additional_security_group_ids = [dependency.network.outputs.consul_security_group_id, dependency.network.outputs.monitoring_security_group_id]

  worker_groups = [
    {
      name                 = "workers"
      instance_type        = local.vars.deployment_vars.worker_instance_type
      asg_desired_capacity = local.vars.deployment_vars.num_workers
      asg_min_size         = local.vars.deployment_vars.cluster_autoscale_min_workers
      asg_max_size         = local.vars.deployment_vars.cluster_autoscale_max_workers
      tags = concat([{
        key                 = "Name"
        value               = "${local.vars.id}-workers-1"
        propagate_at_launch = true
      }
      ])
    }
  ]
}
