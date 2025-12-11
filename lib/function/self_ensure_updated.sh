#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"

# Ensure brew packages are up to date
#
# Usage:
#   laptop_brew_ensure_updated
#
laptop_self_ensure_updated() {
  laptop_step_upgrade_start "laptop updated"

  if brew list w5s/tap/laptop &>/dev/null; then
    laptop_step_eval "brew upgrade w5s/tap/laptop --fetch-HEAD"
    return
  else
    laptop_step_status "pass"
  fi
}
