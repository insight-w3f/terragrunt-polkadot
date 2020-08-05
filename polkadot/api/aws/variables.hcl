locals {
  run = yamldecode(file(find_in_parent_folders("run.yml")))
  settings = yamldecode(file(find_in_parent_folders("settings.yml")))
  secrets = yamldecode(file(find_in_parent_folders("secrets.yml")))

  deployment_id_label_order = local.settings.deployment_id_label_order
  deployment_id = join(".", [ for i in local.deployment_id_label_order : lookup(local.run, i)])
  deployment_vars = yamldecode(file("${find_in_parent_folders("deployments")}/${local.deployment_id}.yaml"))

  ssh_profile_name = local.deployment_vars.ssh_profile_name
  ssh_profile = local.secrets.ssh_profiles[index(local.secrets.ssh_profiles.*.name, local.ssh_profile_name)]

  # Imports
  versions = yamldecode(file("versions.yaml"))[local.run.environment]

  # Labels
  id_label_order = local.settings.id_label_order
  id = join("-", [ for i in local.id_label_order : lookup(local.run, i)])
  name_label_order = local.settings.name_label_order
  name = join("", [ for i in local.name_label_order : title(lookup(local.run, i))])

  tags_clouds = {
    aws = { for t in local.remote_state_path_label_order : t => lookup(local.run, t) }
  }
  tags = lookup(local.tags_clouds, local.run.provider)

  # Remote State
  remote_state_path_label_order = local.settings.remote_state_path_label_order
  remote_state_path = join("/", [ for i in local.remote_state_path_label_order : lookup(local.run, i)])
}