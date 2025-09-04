Q ?= @
SHELL_SRC_FILE ?= $(shell find . -iname 'bin/*' -o -iname '*.sh' -o -iname '*.bash')

.PHONY: setup
setup:
	brew install shellcheck
	brew install shfmt

.PHONY: lint
lint:
	$(Q)shellcheck $(filter-out $(wildcard **/*.zsh), $(SHELL_SRC_FILE))

.PHONY: format
format:
	$(Q)shfmt --write $(SHELL_SRC_FILE)

.PHONY: test
test:
	$(Q) ./test/suite.sh

.PHONY: validate
validate: lint test
