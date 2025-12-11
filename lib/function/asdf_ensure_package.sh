#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

# Install asdf `package` if not present
#
# Usage:
#   laptop_asdf_ensure_package <package> <version> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_asdf_ensure_package() {
  local package="$1"
  local version="${2:-latest}"
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
  current_resource_status=$([ "$(basename "$(asdf where nodejs)" 2>/dev/null)" = "$version" ] && echo "present" || echo "absent")
  local message="asdf '$package' '$version'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec \
        asdf install "$package" "$version" &&
        asdf set --home "$package" "$version"
    else
      laptop_step_exec \
        asdf set --home "$package" "$version"
    fi
  fi
}
