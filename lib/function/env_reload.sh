#!/usr/bin/env bash

# Reload the laptop environment
#
# Usage:
#   laptop_env_reload
#
laptop_env_reload() {
  if [ -f "$HOME/.profile" ]; then
    # shellcheck disable=SC1091
    source "$HOME/.profile"
  fi
  # shellcheck disable=SC1091
  source "$LAPTOP_HOME/lib/env.sh"
}
