SHELL := /bin/bash -euo pipefail
.PHONY

## ----------------------------------------------------------------------
## Makefile to run terragrunt commands to setup nodes for polkadot
## ----------------------------------------------------------------------

tg_cmd = terragrunt $(1) --terragrunt-source-update --auto-approve --terragrunt-non-interactive --terragrunt-working-dir $(2)

help: ## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

install-deps-ubuntu:	## Install basics to run node on mac - developers should do it manually
	./scripts/install-deps-ubuntu.sh

install-deps-mac: 	## Install basics to run node on ubuntu - developers should do it manually
	./scripts/install-deps-brew.sh

clear-cache:	## Clear the cache of files left by terragrunt
	find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \; && \
	find . -type d -name ".terraform" -prune -exec rm -rf {} \;

###############
# Network setup
###############
apply-network:
	$(call tg_cmd,apply,polkadot/aws/label) ; \
	$(call tg_cmd,apply-all,polkadot/aws/network) ; \
	$(call tg_cmd,apply,polkadot/aws/vpc) ; \
	$(call tg_cmd,apply-all,polkadot/aws/security-groups)

destroy-network:
	$(call tg_cmd,destroy-all,polkadot/aws/network)
	$(call tg_cmd,destroy-all,polkadot/aws/security-groups) ; \

####################
# Single Public Node
####################
apply-public-node-single:
	$(call tg_cmd,apply-all,polkadot/aws/public-nodes/single)

destroy-public-node-single:
	$(call tg_cmd,destroy,polkadot/aws/public-nodes/single)

######################
# git actions - WIP!!!
######################
clone-all:	## Clones all the sub repos
	meta git clone .; \
	python scripts/subdir_cmd.py clone_all
