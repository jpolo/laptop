#!/usr/bin/env bash

laptop::ensure_package__xcode-command-line-tools() {
  laptop::step_start "- Ensure XCode Command Line Tools"

  if laptop::command_exists "xcode-select"; then
    if ! [ -x "$(command -v gcc)" ]; then
      laptop::step_exec xcode-select --install;
    else
      laptop::step_ok
    fi
  else
    laptop::step_pass
  fi
}
