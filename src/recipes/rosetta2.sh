#!/usr/bin/env bash

laptop_ensure_package__rosetta2() {
  # Install Rosetta
  laptop_step_start "- Ensure Rosetta 2"
  if ! is_arm; then
    laptop_step_pass
  elif ! laptop_command_exists "softwareupdate"; then
    laptop_step_pass
  elif ! test -f /Library/Apple/usr/share/rosetta/rosetta; then
    laptop_step_exec sudo softwareupdate --install-rosetta --agree-to-license
  else
    laptop_step_ok
  fi
}
