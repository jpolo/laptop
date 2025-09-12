#!/usr/bin/env bash

# Ensure brew packages are up to date
#
# Usage:
#   laptop_ensure_apt_updated
#
laptop_ensure_brew_updated() {
  laptop_step_start "- Upgrade brew"
  laptop_step_eval "brew upgrade --quiet"
}
