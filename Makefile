# Include Core
# The following files will be included before
# 1. Makefile.local (⚠️ This file should never be versioned)
# 2. Makefile.config
# 3. .modules/core.mk (default values)
# 4. .modules/*/module.mk
include .modules/core.mk

# Set a variable in a file (portable across BSD/GNU sed)
define set_var
	sed -i.bak 's|^$(1)=.*|$(1)=$(2)|' $(3)
	rm -f $(3).bak
endef

.PHONY: project-setup
project-setup:
	$(Q)brew install augeas --quiet
	$(Q)brew install shfmt --quiet
	$(Q)brew install shellcheck --quiet
.setup:: project-setup

.PHONY: project-test
project-test:
	$(Q) ./test/suite.sh
.test:: project-test

.PHONY: install
install: ## Install laptop configuration
# Install folders
	$(Q)mkdir -p $(INSTALL_PREFIX)
	$(Q)cp -r bin lib profile share $(INSTALL_PREFIX)
# add LAPTOP_HOME to bin/laptop
	$(Q)$(call set_var,LAPTOP_HOME,$${LAPTOP_HOME:-"$(realpath $(INSTALL_PREFIX))"},$(INSTALL_PREFIX)/bin/laptop)
	$(Q)$(call set_var,LAPTOP_INSTALL_BREW_PACKAGE,$${LAPTOP_INSTALL_BREW_PACKAGE:-$(INSTALL_BREW_PACKAGE)},$(INSTALL_PREFIX)/bin/laptop)


.PHONY: pull-upstream
pull-upstream: ## Pull upstream changes from GitHub
	$(Q)gh repo sync $(CI_PROJECT_PATH) -b main

