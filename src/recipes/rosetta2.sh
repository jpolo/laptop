#!/usr/bin/env bash

ensure_package__rosetta2() {
  # Install Rosetta
  _laptop_step_start "- Ensure Rosetta 2"
  if ! is_arm; then
    _laptop_step_pass
  elif ! command_exists "softwareupdate"; then
    _laptop_step_pass
  elif ! test -f /Library/Apple/usr/share/rosetta/rosetta; then
    _laptop_step_exec sudo softwareupdate --install-rosetta  --agree-to-license
  else
    _laptop_step_ok
  fi
}
