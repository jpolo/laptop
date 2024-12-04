#!/usr/bin/env bash

laptop::ensure_defaults() {
  laptop::step_start "- Ensure defaults $*"
  if laptop::command_exists "defaults"; then
    laptop::step_exec defaults write "$*"
  else
    laptop::step_pass
  fi
}
