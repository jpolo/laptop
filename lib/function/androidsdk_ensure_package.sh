#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

# Ensure androidsdk package is installed
#
# Usage:
#   laptop_androidsdk_ensure_package <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_androidsdk_ensure_package() {
  local package="$1"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local current_resource_status
  current_resource_status=$(android sdk list | grep -q "$package" && echo "present" || echo "absent")
  local message="android sdk '$package'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_eval "android sdk install '$package'"
    else
      laptop_step_eval "android sdk remove '$package'"
    fi
  fi
}
