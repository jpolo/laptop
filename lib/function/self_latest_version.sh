#!/usr/bin/env bash

# Returns the latest available version of laptop from the remote
#
# Resolution order:
#   1. Homebrew install: stable version from `brew info`
#   2. Git install: highest semver tag from remote
#   3. Fallback: "unknown"
#
# Usage:
#   laptop_self_latest_version
#
laptop_self_latest_version() {
  local version

  if [[ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]] && brew list "$LAPTOP_INSTALL_BREW_PACKAGE" &>/dev/null; then
    version=$(HOMEBREW_NO_AUTO_UPDATE=1 brew info --json=v1 "$LAPTOP_INSTALL_BREW_PACKAGE" 2>/dev/null \
      | grep -o '"stable":"[^"]*"' | head -1 | cut -d'"' -f4)
    [[ -n "$version" ]] && echo "$version" && return 0
  fi

  if [[ -d "$LAPTOP_HOME/.git" ]]; then
    version=$(git -C "$LAPTOP_HOME" ls-remote --tags origin 2>/dev/null \
      | awk '{print $2}' \
      | grep -E '^refs/tags/v?[0-9]+\.[0-9]+' \
      | grep -v '\^{}' \
      | sed 's|refs/tags/||' \
      | sort -V \
      | tail -1)
    [[ -n "$version" ]] && echo "$version" && return 0
  fi

  echo "unknown"
}
