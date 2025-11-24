#!/usr/bin/env bash

# Run every steps in alphabetic order (in a separate shell instance)
#
# Usage:
#   laptop_setup_steps <steps_dir>
#
laptop_setup_steps() {
  local steps_dir
  steps_dir=${1:-"$(laptop_profile_dir)/steps"}
  local shell=zsh
  local script_files
  script_files=$(find "$steps_dir" -maxdepth 1 -mindepth 1 -name '*.sh' -o -name "*.zsh" -type f | sort)

  for script_file in $script_files; do
    laptop_shell_exec "$shell" "$script_file"
  done
}
