#!/usr/bin/env bash

laptop::ensure_directory() {
  local directory="$1"
  laptop::step_start "- Ensure directory '$directory'"
  if [ ! -d "$directory" ]; then
    laptop::step_eval "mkdir -p $(quote "$directory")"
  else
    laptop::step_ok
  fi
}
