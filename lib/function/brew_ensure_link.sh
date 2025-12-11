#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

# Install brew link for `package` if not present
#
# Usage:
#   laptop_brew_ensure_link <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_brew_ensure_link() {
  local package=${1}

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

  laptop_step_start_status "$resource_status" "unknown" "brew link '$package'"
  if [ "$resource_status" = "present" ]; then
    laptop_step_exec brew link --force "$package"
  else
    laptop_step_exec brew unlink "$package"
  fi
}
