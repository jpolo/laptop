#!/usr/bin/env bash

# Ensure sdkmanager package is installed
#
# Usage:
#   laptop_sdkmanager_ensure_package <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_sdkmanager_ensure_package() {
  local package="$1"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  laptop_step_start_status "$resource_status" "sdkmanager '$package'"
  if [ "$resource_status" = "present" ]; then
    laptop_step_eval "sdkmanager --install '$package'"
  else
    laptop_step_eval "sdkmanager --uninstall '$package'"
  fi
}
