Q=@
SHELL_SRC_FILE=$(wildcard **/*.sh  **/*.zsh **/*.bash)

.PHONY: setup
setup:
	brew install shellcheck
	brew install shfmt

.PHONY: lint
lint:
	shellcheck $(filter-out $(wildcard **/*.zsh), $(SHELL_SRC_FILE))

.PHONY: format
format:
	$(Q)shfmt --write $(SHELL_SRC_FILE)
