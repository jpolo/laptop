#!/usr/bin/env bash

# Add repo_key to apt key registry
#
# Usage:
#   laptop::ensure_apt_key <repo_key>
#
laptop::ensure_apt_key() {
  local repo_key="$1"
  laptop::step_start "- Ensure apt key '$repo_key'"
  laptop::step_eval "! wget -qO - '$repo_key' | sudo apt-key add -"
}
