#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"
laptop_require "laptop_log"

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
      # Download first so a failed curl does not become a successful empty bash -c.
      # Run attached to the terminal (no NONINTERACTIVE/CI) so a fresh Mac can
      # prompt for sudo; CI/non-TTY still auto-noninteractive via Homebrew itself.
      local installer
      if ! installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh); then
        echo ""
        laptop_step_status "fail"
        laptop_log error "Failed to download Homebrew installer"
      else
        laptop_step_exec --interactive -- /bin/bash -c "$installer"
        # if brew not found
        for prefix in "/opt/homebrew" "/usr/local" "$HOME/.linuxbrew" "/home/linuxbrew/.linuxbrew"; do
          if [ -f "$prefix/bin/brew" ]; then
            eval "$("$prefix/bin/brew" shellenv)"
            break
          fi
        done
      fi
    else
      laptop_step_status "fail"
    fi
  fi
}
