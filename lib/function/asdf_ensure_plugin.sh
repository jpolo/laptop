#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

# Install asdf plugin `name` if not present
#
# Usage:
#   laptop_asdf_ensure_plugin <name> <url> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_asdf_ensure_plugin() {
  local name="$1"
  local url="$2"
  # parse options
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
  current_resource_status=$(asdf plugin list 2>/dev/null | grep -Fq "$name"  && echo "present" || echo "absent")
  local message="asdf plugin '$name'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec asdf plugin add "$name" "$url"
    else
      laptop_step_exec asdf plugin remove "$name"
    fi
  fi
}
