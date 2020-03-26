#!/usr/bin/env bash
set -euxo pipefail
#1
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y libssl-dev build-essential automake pkg-config libtool libffi-dev libgmp-dev libyaml-cpp-dev
sudo apt-get install -y python3.7-dev libsecp256k1-dev python3-pip curl git zip

#2
pip3 install requests==2.20.0
pip3 install cookiecutter preptools ansible awscli
pip install fire

#3
wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip -O /tmp/terraform.zip
unzip /tmp/terraform.zip -d /tmp/
sudo mv /tmp/terraform /usr/local/bin/terraform
terraform --version

#4
wget --no-check-certificate https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.2/terragrunt_linux_amd64 -O /tmp/terragrunt
chmod +x /tmp/terragrunt
sudo mv /tmp/terragrunt /usr/local/bin/terragrunt
terragrunt --version

#5
wget https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip -O /tmp/packer.zip
unzip /tmp/packer.zip -d /tmp/
sudo mv /tmp/packer /usr/local/bin
packer --version

#6
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm i -g meta

#7 - Verify
ansible --version
cookiecutter --version
terragrunt -v
terraform -v
packer -v
meta --version