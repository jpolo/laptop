.PHONY: install
install:
	brew install shellcheck

.PHONY: lint
lint:
	shellcheck **/*.{sh,zsh}
