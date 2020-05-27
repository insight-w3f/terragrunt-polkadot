SHELL := /bin/bash -euo pipefail
.PHONY: test

## ----------------------------------------------------------------------
## Makefile to run terragrunt commands to setup nodes for polkadot
## ----------------------------------------------------------------------

help: ## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

clear-cache:	                ## Clear the cache of files left by terragrunt
	@find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \; && \
	find . -type d -name ".terraform" -prune -exec rm -rf {} \; && echo 'cleared cache'

clear-configs:	                ## Clear the cache of files left by terragrunt
	@find . -type f -name "*.tfvars" -prune -exec rm {} \; && \
    find . -type f -name "global.yaml" -prune -exec rm {} \; && \
    find . -type f -name "secrets.yaml" -prune -exec rm {} \; && echo 'cleared configs'

