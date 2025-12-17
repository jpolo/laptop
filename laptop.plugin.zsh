#!/usr/bin/env zsh
# shellcheck disable=SC1071

# Add the bin directory to your PATH
export PATH="$PATH:$(dirname $(realpath $0))/bin"

# Set the default installation method for laptop plugins
export LAPTOP_INSTALL_METHOD=${LAPTOP_INSTALL_METHOD:-"zinit"}
