# Include Core
# The following files will be included before
# 1. Makefile.local (⚠️ This file should never be versioned)
# 2. Makefile.config
# 3. .modules/core.mk (default values)
# 4. .modules/*/module.mk
include .modules/core.mk

.PHONY: project-setup
project-setup: ## Run all tests
	$(Q)brew install augeas --quiet
.setup:: project-setup

.PHONY: test
test: ## Run all tests
	$(Q) ./test/suite.sh

.PHONY: validate
validate: lint test

.PHONY: install
install: ## Install laptop configuration
# Install folders
	$(Q)mkdir -p $(INSTALL_PREFIX)
	$(Q)cp -r bin lib profile share $(INSTALL_PREFIX)
# add LAPTOP_HOME to bin/laptop
	$(Q)sed -i '' "s|^LAPTOP_HOME=.*|LAPTOP_HOME=\$${LAPTOP_HOME:-\"$(realpath $(INSTALL_PREFIX))\"}|" $(INSTALL_PREFIX)/bin/laptop
