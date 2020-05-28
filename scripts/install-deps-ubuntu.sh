#!/usr/bin/env bash
set -euxo pipefail

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential
sudo apt-get install -y python3.7-dev python3-pip

wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip -O /tmp/terraform.zip
unzip /tmp/terraform.zip -d /tmp/
sudo mv /tmp/terraform /usr/local/bin/terraform
terraform --version

wget --no-check-certificate https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.2/terragrunt_linux_amd64 -O /tmp/terragrunt
chmod +x /tmp/terragrunt
sudo mv /tmp/terragrunt /usr/local/bin/terragrunt
terragrunt --version

wget https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip -O /tmp/packer.zip
unzip /tmp/packer.zip -d /tmp/
sudo mv /tmp/packer /usr/local/bin
packer --version

ansible --version
packer -v
terragrunt -v
terraform -v
