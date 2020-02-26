
variable "playbook_file_path" {}
variable "private_key_path" {}
//variable "user" {}

module "ansible" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=master"
  playbook_file_path = var.playbook_file_path
  private_key_path = var.private_key_path
  user = "ubuntu"

  inventory_template = "${path.module}/ansible_inventory.tpl"
  inventory_template_vars = {
    aws_ip = data.aws_instances.sentries.public_ips[0]
    validators_ip = data.packet_device.this.access_public_ipv4
  }
}

