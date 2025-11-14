
DEVCONTAINER := devcontainer

ifneq ($(wildcard .devcontainer),)
	DEVCONTAINER_ENABLED ?= true
endif

ifneq ($(call filter-false,$(DEVCONTAINER_ENABLED)),)
## DevContainer flags added for each command
DEVCONTAINER_FLAGS ?= --workspace-folder .

devcontainers-cli:
	$(Q)if ! command devcontainer --version &>/dev/null; then \
		echo "Installing Dev Containers CLI..."; \
		npm install -g @devcontainers/cli; \
	fi

devcontainer-build: devcontainers-cli
	$(Q)${DEVCONTAINER} build $(DEVCONTAINER_FLAGS)

devcontainer-up: devcontainers-cli
	$(Q)${DEVCONTAINER} up $(DEVCONTAINER_FLAGS)

devcontainer-start: devcontainer-up
	$(Q)${DEVCONTAINER} exec $(DEVCONTAINER_FLAGS) /bin/zsh

.PHONY: .setup
.setup:: devcontainers-cli # Add `@devcontainers/cli` to `make setup`
endif

