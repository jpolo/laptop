#!/usr/bin/env bash

# Ensure apt packages are up to date
#
# Usage:
#   laptop_ensure_apt_updated
#
laptop_ensure_apt_updated() {
  laptop_step_start "- Ensure APT updated"
  # shellcheck disable=SC2012
  if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
    laptop_step_exec sudo apt-get update
  else
    laptop_step_ok
  fi
}
