#!/usr/bin/env bash

laptop_package_ensure__xcode-command-line-tools() {
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  laptop_step_start_status "$resource_status" "XCode Command Line Tools"

  if laptop_command_exists "xcode-select"; then
    if [ "$resource_status" = "present" ]; then
      if ! [ -x "$(command -v gcc)" ]; then
        laptop_step_exec xcode-select --install
      else
        laptop_step_ok
      fi
    else
      laptop_step_eval "xcode-select --uninstall"
    fi
  else
    laptop_step_pass
  fi
}
