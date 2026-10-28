#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"
laptop_require "laptop_brew_package_installed"

# Ensure brew packages are up to date
#
# Usage:
#   laptop_brew_ensure_updated
#
laptop_self_ensure_updated() {
  if [ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ] && laptop_brew_package_installed "$LAPTOP_INSTALL_BREW_PACKAGE"; then
    laptop_step_upgrade_start "laptop updated (brew)"
    laptop_step_exec brew upgrade "$LAPTOP_INSTALL_BREW_PACKAGE" --fetch-HEAD
  fi
}
