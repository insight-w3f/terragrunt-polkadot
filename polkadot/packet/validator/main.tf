resource "packet_project" "this" {
  name = var.project_id
}

resource "packet_project_ssh_key" "key" {
  name = var.name
  public_key = var.public_key
  project_id = packet_project.this.id
}

resource "packet_device" "validator" {
  count = var.node_count

  hostname = "${var.name}-${count.index}"
  plan = var.machine_type
  facilities = [var.location]
  operating_system = "ubuntu_18_04"
  billing_cycle = "hourly"
  project_id = packet_project.this.id

  project_ssh_key_ids = [packet_project_ssh_key.key.id]
}

module "ansible_configuration" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.5.0"

  ip = packet_device.validator.*.access_public_ipv4[0]

  private_key_path = var.private_key_path

  user = var.ssh_user

  playbook_file_path = var.playbook_file_path
  roles_dir = var.roles_dir

  playbook_vars = var.playbook_vars
}
