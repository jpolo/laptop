#!/usr/bin/env bash

laptop_package_ensure__rosetta2() {
  local resource_status="present"

  local current_resource_status
  current_resource_status=$(test -f /Library/Apple/usr/share/rosetta/rosetta && echo "present" || echo "absent")
  local message="Rosetta 2"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  # Install Rosetta
  if ! test arm64 = "$(uname -m)" || ! laptop_command_exists "softwareupdate"; then
    laptop_step_pass
  else
    if [ "$current_resource_status" = "$resource_status" ]; then
      laptop_step_ok
    else
      laptop_step_exec sudo softwareupdate --install-rosetta --agree-to-license
    fi
  fi
}
