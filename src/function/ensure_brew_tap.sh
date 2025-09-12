#!/usr/bin/env bash

# Install brew tap `tap` if not present
#
# Usage:
#   laptop_ensure_brew_tap <tap>
#
laptop_ensure_brew_tap() {
  local tap="$1"
  laptop_step_start "- Ensure brew tap '$tap'"
  laptop_step_eval "brew tap $tap"
}
