#!/usr/bin/env bash

# Add repo_key to apt key registry
#
# Usage:
#   laptop_ensure_apt_key <repo_key>
#
laptop_ensure_apt_key() {
  local repo_key="$1"
  laptop_step_start "- Ensure apt key '$repo_key'"
  laptop_step_eval "! wget -qO - '$repo_key' | sudo apt-key add -"
}
