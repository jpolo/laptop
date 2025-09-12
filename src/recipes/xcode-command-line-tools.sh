#!/usr/bin/env bash

laptop_ensure_package__xcode-command-line-tools() {
  laptop_step_start "- Ensure XCode Command Line Tools"

  if laptop_command_exists "xcode-select"; then
    if ! [ -x "$(command -v gcc)" ]; then
      laptop_step_exec xcode-select --install
    else
      laptop_step_ok
    fi
  else
    laptop_step_pass
  fi
}
