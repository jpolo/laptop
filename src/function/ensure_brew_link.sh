#!/usr/bin/env bash

# Install brew link for `package` if not present
#
# Usage:
#   laptop_ensure_brew_link <package>
#
laptop_ensure_brew_link() {
  local package=${1}

  laptop_step_start "- Ensure brew link '$package'"
  laptop_step_exec brew link --force "$package"
}
