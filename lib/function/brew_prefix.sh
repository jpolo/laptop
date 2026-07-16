#!/usr/bin/env bash

# Returns the Homebrew prefix without resolving a specific formula
#
# Usage:
#   laptop_brew_prefix
#
laptop_brew_prefix() {
  if [[ -n "$HOMEBREW_PREFIX" ]]; then
    echo "$HOMEBREW_PREFIX"
  elif [[ -d /opt/homebrew ]]; then
    echo /opt/homebrew
  elif [[ -d /usr/local/Homebrew ]]; then
    echo /usr/local
  else
    brew --prefix 2>/dev/null
  fi
}
