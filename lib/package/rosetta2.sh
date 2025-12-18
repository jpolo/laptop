#!/usr/bin/env bash

laptop_require "laptop_command_exists"
laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_step_exec"

laptop_package_ensure__rosetta2() {
  local resource_status="present"

  local current_resource_status
  current_resource_status=$(test -f /Library/Apple/usr/share/rosetta/rosetta && echo "present" || echo "absent")
  local message="Rosetta 2"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  # Install Rosetta
  if ! test arm64 = "$(uname -m)" || ! laptop_command_exists "softwareupdate"; then
    laptop_step_status "pass"
  else
    if [ "$current_resource_status" = "$resource_status" ]; then
      laptop_step_status "ok"
    else
      laptop_step_exec sudo softwareupdate --install-rosetta --agree-to-license
    fi
  fi
}
