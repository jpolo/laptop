#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

# Ensure apt packages are up to date
#
# Usage:
#   laptop_apt_ensure_updated
#
laptop_apt_ensure_updated() {
  local current_status
  # shellcheck disable=SC2012
  current_status=$([ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ] && echo "absent" || echo "present")
  laptop_step_upgrade_start "apt updated"
  if [ "$current_status" = "absent" ]; then
    laptop_step_exec sudo apt-get update
  else
    laptop_step_status "ok"
  fi
}
