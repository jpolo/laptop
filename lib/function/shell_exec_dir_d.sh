#!/usr/bin/env bash

laptop_require "laptop_shell_exec"

# Run every shell file in alphabetic order (in a separate shell instance)
#
# Usage:
#   laptop_shell_exec_dir_d <steps_dir>
#
laptop_shell_exec_dir_d() {
  local steps_dir="$1"
  local shell=zsh
  local script_files
  script_files=$(find "$steps_dir" -maxdepth 1 -mindepth 1 \( -name '*.sh' -o -name "*.zsh" \) -type f | sort)

  while IFS= read -r script_file; do
    [[ -n "$script_file" ]] && laptop_shell_exec "$shell" "$script_file"
  done <<< "$script_files"
}
