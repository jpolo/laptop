#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_step_eval"

# Ensure the user is logged into the Azure CLI (az).
# Logs in when not already authenticated.
#
# Usage:
#   laptop_az_ensure_login [--tenant <tenant>]
#
# Options:
#   --tenant <tenant>
#
laptop_az_ensure_login() {
  local tenant=""
  local resource_status="present"
  local resource_current_status

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -t | --tenant)
      tenant="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  if az account show &>/dev/null; then
    resource_current_status="present"
  else
    resource_current_status="absent"
  fi

  laptop_step_start_status "$resource_status" "$resource_current_status" "Azure account logged in"
  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  elif [ -n "$tenant" ]; then
    laptop_step_eval "az login --tenant \"$tenant\""
  else
    laptop_step_eval "az login"
  fi
}
