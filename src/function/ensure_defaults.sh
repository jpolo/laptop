#!/usr/bin/env bash

laptop_ensure_defaults() {
  laptop_step_start "- Ensure defaults $*"
  if laptop_command_exists "defaults"; then
    laptop_step_exec defaults write "$*"
  else
    laptop_step_pass
  fi
}
