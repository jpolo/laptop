#!/usr/bin/env bash

# Install brew link for `package` if not present
#
# Usage:
#   laptop::ensure_brew_link <package>
#
laptop::ensure_brew_link() {
  local package=${1}

  laptop::step_start "- Ensure brew link '$package'"
  laptop::step_exec brew link --force "$package"
}
