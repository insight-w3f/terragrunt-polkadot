data "aws_region" "this" {}

resource "random_pet" "this" {}

module "ec2" {
  source = "github.com/insight-infrastructure/terraform-aws-ec2-basic.git?ref=master"

  name = var.name

  monitoring = var.monitoring
  create_eip = var.create_eip

  ebs_volume_size = var.ebs_volume_size
  root_volume_size = var.root_volume_size

  instance_type = var.instance_type
  volume_path = var.volume_path

  subnet_id = var.subnet_id
  user_data = var.user_data

  local_public_key = var.public_key_path
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = var.tags
}

module "ansible_configuration" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.5.0"

  ip = module.ec2.public_ip

  private_key_path = var.private_key_path

  user = var.ssh_user

  playbook_file_path = var.playbook_file_path
  roles_dir = var.roles_dir

  playbook_vars = var.playbook_vars
}



