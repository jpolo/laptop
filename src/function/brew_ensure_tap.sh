#!/usr/bin/env bash

# Install brew tap `tap` if not present
#
# Usage:
#   laptop_brew_ensure_tap <tap> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_brew_ensure_tap() {
  local tap="$1"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  laptop_step_start_status "$resource_status" "brew tap '$tap'"
  if [ "$resource_status" = "present" ]; then
    laptop_step_eval "brew tap $tap"
  else
    laptop_step_exec brew untap "$tap"
  fi
}
