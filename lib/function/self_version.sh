#!/usr/bin/env bash

laptop_require "laptop_brew_package_installed"
laptop_require "laptop_brew_package_version"

# Returns the current installed version of laptop
#
# Resolution order:
#   1. Homebrew install: cellar directory version
#   2. Git install: `git describe --tags --always` (nearest tag, or short SHA)
#   3. Fallback: $LAPTOP_VERSION env var
#
# Usage:
#   laptop_self_version
#
laptop_self_version() {
  local version

  if [[ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]] && laptop_brew_package_installed "$LAPTOP_INSTALL_BREW_PACKAGE"; then
    version=$(laptop_brew_package_version "$LAPTOP_INSTALL_BREW_PACKAGE")
    [[ -n "$version" ]] && echo "$version" && return 0
  fi

  if [[ -d "$LAPTOP_HOME/.git" ]]; then
    version=$(git -C "$LAPTOP_HOME" describe --tags --always 2>/dev/null)
    [[ -n "$version" ]] && echo "$version" && return 0
  fi

  echo "${LAPTOP_VERSION:-unknown}"
}
