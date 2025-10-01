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
  laptop_step_start_status "$resource_status" "unknown" "Git config '$name'='${value:-"<custom>"}'"
  if [ "$resource_status" = "present" ]; then
    if [ -z "$(git config --global "$name")" ]; then
      if [ -z "${value}" ]; then
        echo "Git: Please enter value for '$name'"
        read -r value
      fi

      laptop_step_exec git config --global "$name" "$value"
    else
      laptop_step_ok
    fi
  else
    laptop_step_eval "git config --global --unset $name"
  fi
}
