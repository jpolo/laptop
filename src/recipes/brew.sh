#!/usr/bin/env bash

laptop_ensure_package__brew() {
  # Install Homebrew
  local brew_present
  brew_present=$(env -i zsh --login -c 'command -v brew')
  laptop_step_start "- Ensure package manager 'brew'"

  if [ -z "$brew_present" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
      # eval "$(/opt/homebrew/bin/brew shellenv)" && \;
      laptop_step_ok
  else
    laptop_step_ok
  fi
}
