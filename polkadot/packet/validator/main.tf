
module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

resource "packet_project" "this" {
  name = var.project_name
}

resource "packet_project_ssh_key" "key" {
  name = var.name
  public_key = var.public_key
  project_id = packet_project.this.id
}

resource "packet_device" "validator" {
//  count = var.node_count
//  hostname = "${var.name}-${count.index}"

  hostname = var.name
  plan = var.machine_type
  facilities = [var.location]
  operating_system = "ubuntu_18_04"
  billing_cycle = "hourly"
  project_id = packet_project.this.id

  project_ssh_key_ids = [packet_project_ssh_key.key.id]

  tags = values(module.label.tags)
}
