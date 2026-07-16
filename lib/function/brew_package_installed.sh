#!/usr/bin/env bash

laptop_require "laptop_brew_prefix"

# Returns the cellar directory name for a brew package (last path component)
#
# Usage:
#   .laptop_brew_cellar_name <package>
#
.laptop_brew_cellar_name() {
  echo "${1##*/}"
}

# Returns 0 when a brew package is installed (filesystem check, no brew list)
#
# Usage:
#   laptop_brew_package_installed <package>
#
laptop_brew_package_installed() {
  local prefix cellar_name
  prefix=$(laptop_brew_prefix) || return 1
  cellar_name=$(.laptop_brew_cellar_name "$1")
  [[ -d "$prefix/Cellar/$cellar_name" ]]
}
