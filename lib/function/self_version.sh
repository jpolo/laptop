#!/usr/bin/env bash

# Returns the current installed version of laptop
#
# Resolution order:
#   1. Homebrew install: `brew list --versions`
#   2. Git install: `git describe --tags --always` (nearest tag, or short SHA)
#   3. Fallback: $LAPTOP_VERSION env var
#
# Usage:
#   laptop_self_version
#
laptop_self_version() {
  local version

  if [[ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]] && brew list "$LAPTOP_INSTALL_BREW_PACKAGE" &>/dev/null; then
    version=$(brew list --versions "$LAPTOP_INSTALL_BREW_PACKAGE" 2>/dev/null | awk '{print $2}')
    [[ -n "$version" ]] && echo "$version" && return 0
  fi

  if [[ -d "$LAPTOP_HOME/.git" ]]; then
    version=$(git -C "$LAPTOP_HOME" describe --tags --always 2>/dev/null)
    [[ -n "$version" ]] && echo "$version" && return 0
  fi

  echo "${LAPTOP_VERSION:-unknown}"
}
