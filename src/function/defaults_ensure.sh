#!/usr/bin/env bash

# Ensure defaults are set
#
# Usage:
#   laptop_defaults_ensure <domain> <key> <value>
#
laptop_defaults_ensure() {
  laptop_step_start_status "present" "Defaults $*"
  if laptop_command_exists "defaults"; then
    laptop_step_exec defaults write "$*"
  else
    laptop_step_pass
  fi
}
