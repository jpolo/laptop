ifneq ($(wildcard .shellcheckrc shellcheckrc),)
	SHELLCHECK_ENABLED := true
endif

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
	$(Q)[ -x "$$(command -v $(SHELLCHECK))" ] || brew install $(SHELLCHECK)
	$(Q)[ -x "$$(command -v $(SHFMT))" ] || brew install $(SHFMT)
.setup:: shell-setup # Add `shell-setup` to `make setup`

.PHONY: shell-dependencies
shell-dependencies: shell-setup
	$(Q):

ifneq ($(call filter-false,$(SHELLCHECK_ENABLED)),)
#
# Run shellcheck linting
#
.PHONY: shell-lint
shell-lint: shell-dependencies
	@$(call log,info,"[Shell] Lint sources...",1)
	$(Q)$(SHELLCHECK) $(SHELL_FILES)
.lint::	shell-lint # Add `shell-lint` to `make lint`
endif

#
# Run shfmt formatting
#
.PHONY: shell-format
shell-format: shell-dependencies
	@$(call log,info,"[Shell] Format sources...",1)
	$(Q)$(SHFMT) --write $(SHELL_FILES)
.format::	shell-format # Add `shell-format` to `make format`
