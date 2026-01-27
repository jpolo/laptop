#!/usr/bin/env bash

# Profile privacy settings
LAPTOP_PROFILE_PRIVACY="${LAPTOP_PROFILE_PRIVACY:-strict}"
# shellcheck disable=SC2034
LAPTOP_INSTALL_BREW_PACKAGE="w5s/tap/laptop"

# Handlers
# Uncomment to override the default handler

# laptop_handler__logo() {
#   echo "👋 Hello, world!"
# }

# laptop_handler__setup_bootstrap() {
#   laptop_setup_bootstrap
# }

# laptop_handler__setup_shell() {
#   laptop_setup_default_shell
# }
