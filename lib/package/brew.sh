#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"

laptop_package_ensure__brew() {
  # Install Homebrew
  local resource_status="present"
  local current_resource_status
  current_resource_status=$(env -i zsh --login -c 'command -v brew' &>/dev/null && echo "present" || echo "absent")
  local message="Package manager 'brew'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_eval 'NONINTERACTIVE=1 CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
      # if brew not found
      for prefix in "/opt/homebrew" "/usr/local" "$HOME/.linuxbrew" "/home/linuxbrew/.linuxbrew"
      do
        if [ -f "$prefix/bin/brew" ] ; then
          eval "$("$prefix/bin/brew" shellenv)"
          break
        fi
      done
    else
      laptop_step_status "fail"
    fi
  fi
}
