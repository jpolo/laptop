#!/usr/bin/env bash

laptop_directory_ensure() {
  local directory="$1"
  laptop_step_start "- Ensure directory '$directory'"
  if [ ! -d "$directory" ]; then
    laptop_step_eval "mkdir -p $(quote "$directory")"
  else
    laptop_step_ok
  fi
}
