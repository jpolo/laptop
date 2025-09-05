#!/usr/bin/env bash

# Ensure brew packages are up to date
#
# Usage:
#   laptop::ensure_apt_updated
#
laptop::ensure_brew_updated() {
  laptop::step_start "- Upgrade brew"
  laptop::step_eval "brew upgrade --quiet"
}
