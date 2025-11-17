# Directory where this makefile-ci was installed
MAKEFILE_CI_DIR := $(dir $(dir $(lastword $(MAKEFILE_LIST))))
# Directory containing makefile-ci sources (*.mk)
MAKEFILE_CI_SRC := $(MAKEFILE_CI_DIR)src
# Directory containing binaries used by makefiles
MAKEFILE_CI_BIN := $(MAKEFILE_CI_DIR)bin
# Directory containing template files used by makefiles
MAKEFILE_CI_TEMPLATE := $(MAKEFILE_CI_DIR)template

# Features detection

## DotEnv feature enabled
DOTENV_ENABLED ?= true
ifneq ($(wildcard .tool-versions),)
## ASDF feature enabled
ASDF_ENABLED ?= true
endif
ifneq ($(wildcard Dockerfile),)
## Docker feature enabled
DOCKER_ENABLED ?= true
endif
ifneq ($(wildcard .devcontainer),)
## DevContainer feature enabled
DEVCONTAINER_ENABLED ?= true
endif
ifneq ($(wildcard package.json),)
## NodeJS feature enabled
NODEJS_ENABLED ?= true
endif
ifneq ($(wildcard Gemfile),)
## Ruby feature enabled
RUBY_ENABLED ?= true
endif

## Enable Scalingo deployment
SCALINGO_ENABLED ?= false

## Enable Heroku deployment
HEROKU_ENABLED ?= false

# Include variables
include $(MAKEFILE_CI_SRC)/functions.mk
include $(MAKEFILE_CI_SRC)/variables.mk

# Include workflow
include $(MAKEFILE_CI_SRC)/workflow.mk

# Include each module
include $(MAKEFILE_CI_SRC)/cache.mk
include $(MAKEFILE_CI_SRC)/pid.mk
include $(MAKEFILE_CI_SRC)/version.mk
include $(MAKEFILE_CI_SRC)/build-info.mk
include $(MAKEFILE_CI_SRC)/template.mk
include $(MAKEFILE_CI_SRC)/dotenv.mk

ifneq ($(call filter-false,$(DOCKER_ENABLED)),)
include $(MAKEFILE_CI_SRC)/docker.mk
include $(MAKEFILE_CI_SRC)/docker-compose.mk
endif

ifneq ($(call filter-false,$(DEVCONTAINER_ENABLED)),)
include $(MAKEFILE_CI_SRC)/devcontainer.mk
endif

include $(MAKEFILE_CI_SRC)/githooks.mk

include $(MAKEFILE_CI_SRC)/shell.mk

ifneq ($(call filter-false,$(NODEJS_ENABLED)),)
include $(MAKEFILE_CI_SRC)/node.mk
endif

ifneq ($(call filter-false,$(RUBY_ENABLED)),)
include $(MAKEFILE_CI_SRC)/ruby.mk
endif

ifneq ($(call filter-false,$(COCOAPODS_ENABLED)),)
include $(MAKEFILE_CI_SRC)/cocoapods.mk
endif

ifneq ($(call filter-false,$(SCALINGO_ENABLED)),)
include $(MAKEFILE_CI_SRC)/scalingo.mk
endif

ifneq ($(call filter-false,$(HEROKU_ENABLED)),)
include $(MAKEFILE_CI_SRC)/heroku.mk
endif

# End of all declarations

# Export all CI_VARIABLES
$(foreach var,$(CI_VARIABLES),$(eval export $(var)))
