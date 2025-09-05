#!/usr/bin/env bash

# Install brew tap `tap` if not present
#
# Usage:
#   laptop::ensure_brew_tap <tap>
#
laptop::ensure_brew_tap() {
  local tap="$1"
  laptop::step_start "- Ensure brew tap '$tap'"
  laptop::step_eval "brew tap $tap"
}
