#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"

# Ensure brew packages are up to date
#
# Usage:
#   laptop_brew_ensure_updated
#
laptop_brew_ensure_updated() {
  laptop_step_upgrade_start "brew updated"
  laptop_step_eval "brew upgrade --quiet"
}
