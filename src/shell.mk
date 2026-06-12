SHELLCHECK := shellcheck
SHFMT := shfmt

SHELL_FILES ?= $(filter-out ./$(MODULES_PATH)/%, $(shell find . -iname '*.sh' -o -iname '*.bash' 2>/dev/null))

#
# Setup node
#
# This will install node and npm
#
.PHONY: shell-setup
shell-setup:
	$(Q)if [ -n "$(call filter-false,$(SHELLCHECK_ENABLED))" ]; then \
		[ -x "$$(command -v $(SHELLCHECK))" ] || brew install $(SHELLCHECK); \
	fi
	$(Q)[ -x "$$(command -v $(SHFMT))" ] || brew install $(SHFMT)
.setup:: shell-setup # Add `shell-setup` to `make setup`

.PHONY: shell-dependencies
shell-dependencies: shell-setup
	$(Q):

#
# Run shellcheck linting
#
.PHONY: shell-lint
shell-lint: shell-dependencies
	@$(call log,info,"[Shell] Lint sources...",1)
	$(Q)if [ -n "$(strip $(SHELL_FILES))" ]; then \
		$(SHELLCHECK) $(SHELL_FILES); \
	else \
		echo "No shell files found, skipping shell lint."; \
	fi
.lint::	shell-lint # Add `shell-lint` to `make lint`

#
# Run shfmt formatting
#
.PHONY: shell-format
shell-format: shell-dependencies
	@$(call log,info,"[Shell] Format sources...",1)
	$(Q)if [ -n "$(strip $(SHELL_FILES))" ]; then \
		$(SHFMT) --write $(SHELL_FILES); \
	else \
		echo "No shell files found, skipping shell format."; \
	fi
.format::	shell-format # Add `shell-format` to `make format`
