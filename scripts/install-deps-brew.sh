#!/usr/bin/env bash
brew install terraform terragrunt packer ansible python nodejs git
npm i -g meta
sudo pip3 install preptools cookiecutter


# Verify
ansible --version
cookiecutter --version
terragrunt -v
terraform -v
packer -v
meta --version