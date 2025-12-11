#!/usr/bin/env bash

laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"
laptop_require "laptop_step_resource_start_status"

# Install apt `package` if not present
#
# Usage:
#   laptop_apt_ensure_package <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_apt_ensure_package() {
  local package="$1"
  local resource_status="present"
  local with_sudo="$LAPTOP_SUDO"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    --sudo)
      with_sudo="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local sudo_command
  if [ "$with_sudo" = true ]; then
    sudo_command="sudo"
  fi

  local current_resource_status
  current_resource_status=$(dpkg -s "$package" &>/dev/null && echo "present" || echo "absent")

  laptop_step_resource_start_status "$package" --status "$resource_status" --current-status "$current_resource_status"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec "$sudo_command" apt-get install "$package" -yy
    else
      laptop_step_exec "$sudo_command" apt-get remove "$package" -yy
    fi
  fi
}
