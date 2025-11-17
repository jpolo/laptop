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
