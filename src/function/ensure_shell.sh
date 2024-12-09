#!/usr/bin/env bash

laptop::ensure_shell() {
  local target_shell="$1"
  local current_shell
  current_shell="$(basename "$SHELL")"

  laptop::step_start "- Ensure shell '$target_shell'"
  if [ -z "$target_shell" ]; then
    laptop::step_pass
  elif [ "$current_shell" = "$target_shell" ]; then
    laptop::step_ok
  else
    laptop::step_exec sudo chsh -s "/bin/$target_shell"
  fi
}
