#!/usr/bin/env bash

laptop_require "laptop_shell_exec"

# Run every shell file in alphabetic order (in a separate shell instance)
#
# Usage:
#   laptop_shell_exec_dir_d <shell> <steps_dir>
#
laptop_shell_exec_dir_d() {
  local shell="$1"
  local steps_dir="$2"
  local script_file
  local script_files=()

  # Read the file list on a separate stream. Leaving it on stdin hands that
  # pipe to every step, so a TUI (the acli site picker) never sees a terminal:
  # it stays in cooked mode and arrow keys are echoed as escape codes.
  while IFS= read -r script_file; do
    [[ -n "$script_file" ]] && script_files+=("$script_file")
  done < <(find "$steps_dir" -maxdepth 1 -mindepth 1 \( -name '*.sh' -o -name "*.zsh" \) -type f | sort)

  for script_file in "${script_files[@]}"; do
    laptop_shell_exec "$shell" "$script_file"
  done
}
