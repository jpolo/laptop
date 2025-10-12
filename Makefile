# Include Core
# The following files will be included before
# 1. Makefile.local (⚠️ This file should never be versioned)
# 2. Makefile.config
# 3. .modules/core.mk (default values)
# 4. .modules/*/module.mk
include .modules/core.mk

SHELL_SRC_FILES ?= $(shell find . -iname 'bin/*' -o -iname '*.sh' -o -iname '*.bash' 2>/dev/null)
SHELLCHECK := shellcheck
SHFMT := shfmt

.PHONY: setup
setup: ## Setup development environment
	brew install $(SHELLCHECK)
	brew install $(SHFMT)

.PHONY: lint
lint: ## Lint all shell scripts
	$(Q)$(SHELLCHECK) $(filter-out $(wildcard **/*.zsh), $(SHELL_SRC_FILES))

.PHONY: format
format: ## Format all shell scripts
	$(Q)$(SHFMT) --write $(SHELL_SRC_FILES)

.PHONY: test
test: ## Run all tests
	$(Q) ./test/suite.sh

.PHONY: validate
validate: lint test
