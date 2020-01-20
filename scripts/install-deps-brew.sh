#!/usr/bin/env bash
brew install terraform terragrunt packer ansible python nodejs git
npm i -g meta
sudo pip3 install preptools cookiecutter

#wget --no-check-certificate https://github.com/gruntwork-io/terragrunt/releases/download/v0.19.31/terragrunt_linux_amd64 -O /tmp/terragrunt
#chmod +x /tmp/terragrunt
#sudo mv /tmp/terragrunt /usr/local/bin/terragrunt
#terragrunt --version

# Verify
ansible --version
cookiecutter --version
terragrunt -v
terraform -v
packer -v
meta --version