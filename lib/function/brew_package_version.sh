#!/usr/bin/env bash

laptop_require "laptop_brew_prefix"
laptop_require "laptop_brew_package_installed"

# Returns the installed version of a brew package from its cellar directory
#
# Usage:
#   laptop_brew_package_version <package>
#
laptop_brew_package_version() {
  local prefix cellar_name cellar_dir
  prefix=$(laptop_brew_prefix) || return 1
  cellar_name=$(.laptop_brew_cellar_name "$1")
  cellar_dir="$prefix/Cellar/$cellar_name"
  [[ -d "$cellar_dir" ]] || return 1
  # shellcheck disable=SC2012
  ls -1 "$cellar_dir" 2>/dev/null | tail -1
}
