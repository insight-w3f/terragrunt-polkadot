locals {
  run = yamldecode(file(find_in_parent_folders("run.yaml")))
  settings = yamldecode(file(find_in_parent_folders("settings.yaml")))

  # Imports
  versions = yamldecode(file("versions.yaml"))[local.run.environment]
  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))
  deployment_id_order = local.settings.deployment_id_order
  deployment_id = join(".", [ for i in local.deployment_id_order : lookup(local.run, i)])
  deployment_vars = yamldecode(file("${find_in_parent_folders("deployments")}/${local.deployment_id}.yaml"))

  # Labels
  id_label_order = local.settings.id_label_order
  id = join("-", [ for i in local.id_label_order : lookup(local.run, i)])
  name_label_order = local.settings.name_label_order
  name = join("", [ for i in local.name_label_order : title(lookup(local.run, i))])
  tags = { for t in local.remote_state_path_order : t => lookup(local.run, t) }

  # Remote State
  remote_state_path_order = local.settings.remote_state_path_order
  remote_state_path = join("/", [ for i in local.remote_state_path_order : lookup(local.run, i)])

//  versions = {
//    dev = {
//      asg = "master"
//    }
//  }
}