#!/usr/bin/env bash

laptop::ensure_package__brew() {
  # Install Homebrew
  local brew_present
  brew_present=$(env -i zsh --login -c 'command -v brew')
  laptop::step_start "- Ensure package manager 'brew'"

  if [ -z "$brew_present" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
      # eval "$(/opt/homebrew/bin/brew shellenv)" && \;
      laptop::step_ok
  else
    laptop::step_ok
  fi
}
