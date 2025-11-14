#!/usr/bin/env bash

# Install npm package `package` if not present
#
# Usage:
#   laptop_npm_ensure_package <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_npm_ensure_package() {
  local package="$1"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  local resource_current_status
  resource_current_status=$(npm list --global --parseable "$package" | grep "$package" && echo "present" || echo "absent")

  laptop_step_start_status "$resource_status" "$resource_current_status" "NPM package '$package'"

  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_ok
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec npm install --quiet --global "$package"
    else
      laptop_step_exec npm uninstall --quiet --global "$package"
    fi
  fi
}
