#!/usr/bin/env bash

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
  local package_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) package_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  local current_package_status
  current_package_status=$(asdf plugin list | grep -Fq "$name" && echo "present" || echo "absent")
  local message="asdf plugin '$name'"

  if [ "$current_package_status" = "$package_status" ]; then
    laptop_step_start_status "unchanged" "$message"
    laptop_step_ok
  else
    laptop_step_start_status "$package_status" "$message"
    if [ "$package_status" = "present" ]; then
      laptop_step_exec asdf plugin add "$name" "$url"
    else
      laptop_step_exec asdf plugin remove "$name"
    fi
  fi
}
