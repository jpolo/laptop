#!/usr/bin/env bash

ensure_package__rosetta2() {
  # Install Rosetta
  laptop::step_start "- Ensure Rosetta 2"
  if ! is_arm; then
    laptop::step_pass
  elif ! command_exists "softwareupdate"; then
    laptop::step_pass
  elif ! test -f /Library/Apple/usr/share/rosetta/rosetta; then
    laptop::step_exec sudo softwareupdate --install-rosetta  --agree-to-license
  else
    laptop::step_ok
  fi
}
