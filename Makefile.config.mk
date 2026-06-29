# Makefile configuration

# Upstream for core.mk used by make self-update
export MAKEFILE_CORE_URL := https://raw.githubusercontent.com/w5s/makefile-core/main/core.mk

# Git commit format for make self-update
export MAKEFILE_CORE_GIT_COMMIT_FORMAT = gitmoji

# Project name (ex: vesta)
# export CI_PROJECT_NAME ?= <TODO>

# Project namespace (ex: w5s)
# export CI_PROJECT_NAMESPACE ?= <TODO>

## Install prefix
INSTALL_PREFIX ?= /opt/$(CI_PROJECT_NAME)
export INSTALL_PREFIX
