#!/usr/bin/env bash

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
    laptop_step_pass
  fi
}
