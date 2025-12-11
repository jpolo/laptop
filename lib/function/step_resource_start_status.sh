#!/usr/bin/env bash

laptop_require "laptop_step_start_status"

# Display a step with a target status
#
# Usage:
#   laptop_step_resource_start_status <package> [--status present|absent] [--current-status present|absent]
#
# Options:
#   <current_status> present|absent
#   <target_status> present|absent
laptop_step_resource_start_status() {
  local package="${1}"
  local resource_status="present"
  local current_resource_status="unknown"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    --current-status)
      current_resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local message
  if [ "$LAPTOP_PACKAGE_MANAGER" = "apt-get" ]; then
    message="apt package '$package'"
  else
    message="$LAPTOP_PACKAGE_MANAGER package '$package'"
  fi
  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
}
