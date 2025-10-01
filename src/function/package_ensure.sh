#!/usr/bin/env bash

# Install `package` if not present
#
# Usage:
#   laptop_package_ensure <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_package_ensure() {
  local package="${1}"

  # Attempt to launch a function named laptop_package_ensure__$package" if exists
  local recipe_function="laptop_package_ensure__$package"

  if laptop_function_exists "$recipe_function"; then
    $recipe_function "$@"
    return 0
  else
    # pass all arguments
    laptop_package_ensure_default "$@"
  fi
}

laptop_package_ensure_default() {
  # Install using package manager
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "$@"
  elif [ "$LAPTOP_PACKAGE_MANAGER" = "apt-get" ]; then
    laptop_apt_ensure_package "$@"
  else
    laptop_step_fail
  fi
}
