#!/usr/bin/env bash

laptop_package_ensure__brew() {
  # Install Homebrew
  local resource_status="present"
  local current_resource_status
  current_resource_status=$(env -i zsh --login -c 'command -v brew' &>/dev/null && echo "present" || echo "absent")
  local message="Package manager 'brew'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_ok
  else
    if [ "$resource_status" = "present" ]; then
      # shellcheck disable=SC2015
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
        # eval "$(/opt/homebrew/bin/brew shellenv)" && \;
        laptop_step_ok || laptop_step_fail
    else
      laptop_step_fail
    fi
  fi
}
