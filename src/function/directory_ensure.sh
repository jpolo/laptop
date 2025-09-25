#!/usr/bin/env bash

# Ensure that a directory exists, creating parent directories as needed.
#
# Usage:
#   laptop_directory_ensure <directory_path>
laptop_directory_ensure() {
  local directory="$1"
  laptop_step_start "- Ensure directory '$(laptop_path_print "$directory")'"
  if [ ! -d "$directory" ]; then
    laptop_step_eval "mkdir -p $(quote "$directory")"
  else
    laptop_step_ok
  fi
}
