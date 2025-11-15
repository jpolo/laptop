#!/usr/bin/env bash

laptop_package_ensure__xcode-command-line-tools() {
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
  current_resource_status=$(test -x "$(command -v gcc)" && echo "present" || echo "absent")
  local message="XCode Command Line Tools"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
  if ! laptop_command_exists "xcode-select"; then
    laptop_step_pass
  elif [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_ok
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec xcode-select --install
    else
      laptop_step_exec sudo xcode-select --reset
    fi
  fi
}
