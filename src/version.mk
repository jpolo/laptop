# Default version
VERSION_DEFAULT := 1.0.0-alpha.0

# File containing source code version
VERSION_FILE := VERSION

ifneq ($(wildcard $(VERSION_FILE)),)
	VERSION := $(shell cat $(VERSION_FILE) 2>/dev/null)
else ifneq ($(wildcard package.json),)
	VERSION := $(shell npm pkg get version | tr -d '"' | tr -d '{}')
endif
## Source code version
VERSION ?= $(VERSION_DEFAULT)

# Target to read or create a default VERSION file at the root of repository
# This version :
#   - has a meaning for the project (e.g., "v1.0.0")
#   - is used to generate a unique build-version
#
# Example:
# 	make version # > 1.0.0-alpha.0
.PHONY: version
version: ## Display app version (ex: 1.0.0)
	@echo $(VERSION)
