#!/usr/bin/env bash

laptop_shell_ensure() {
  local target_shell="$1"
  local current_shell
  current_shell="$(basename "$SHELL")"

  laptop_step_start_status "present" "User shell '$target_shell'"
  if [ -z "$target_shell" ]; then
    laptop_step_pass
  elif [ "$current_shell" = "$target_shell" ]; then
    laptop_step_ok
  else
    laptop_step_exec sudo chsh -s "/bin/$target_shell"
  fi
}
