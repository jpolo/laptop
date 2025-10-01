#!/usr/bin/env bash

# Ensure git config is set
#
# Usage:
#   laptop_git_ensure_config <name> <value> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_git_ensure_config() {
  local name="$1"
  local value="$2"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done

  local current_value
  current_value=$(git config --global "$name")
  local resource_current_status
  resource_current_status=$([[ "$current_value" = "$value" ]] && echo "present" || echo "absent")

  laptop_step_start_status "$resource_status" "$resource_current_status" "Git config '$name'='${value:-"<custom>"}'"

  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_ok
  else
    if [ -z "${value}" ] && [ "$resource_status" = "present" ]; then
      echo "Git: Please enter value for '$name'"
      read -r value
    fi
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec git config --global "$name" "$value"
    else
      laptop_step_exec git config --global --unset "$name"
    fi
  fi
}
