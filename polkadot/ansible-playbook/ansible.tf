
variable "playbook_file_path" {
  description = "The path to the playbook"
  type = string
}
variable "private_key_path" {
  description = "The path to private key"
  type = string
}

module "ansible" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=fix-inv-tpl-local"
  playbook_file_path = var.playbook_file_path
  private_key_path = var.private_key_path
  user = "ubuntu"

  inventory_template = "${path.cwd}/ansible_inventory.tpl"
  inventory_template_vars = {
    aws_ip = data.aws_instances.sentries.public_ips[0]
    validators_ip = data.packet_device.this.access_public_ipv4
  }
}
