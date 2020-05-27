#!/usr/bin/env bash
brew install terraform terragrunt packer ansible python git

# Verify
ansible --version
terragrunt -v
terraform -v
packer -v
