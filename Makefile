# Include Core
# The following files will be included before
# 1. Makefile.local (⚠️ This file should never be versioned)
# 2. Makefile.config
# 3. .modules/core.mk (default values)
# 4. .modules/*/module.mk
include .modules/core.mk

.PHONY: test
test: ## Run all tests
	$(Q) ./test/suite.sh

.PHONY: validate
validate: lint test

.PHONY: install
install: ## Install laptop configuration
	$(Q) mkdir -p $(INSTALL_PREFIX)
	$(Q) cp -r bin lib profile $(INSTALL_PREFIX)
