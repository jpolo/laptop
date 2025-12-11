#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

# Ensure user shell is set
#
# Usage:
#   laptop_shell_ensure <target_shell>
#
#
laptop_shell_ensure() {
  local target_shell="$1"
  local current_shell
  current_shell="$(basename "$SHELL")"
  local resource_status="present"
  local resource_current_status
  resource_current_status=$([[ "$current_shell" = "$target_shell" ]] && echo "present" || echo "absent")

  laptop_step_start_status "$resource_status" "$resource_current_status" "User shell '$target_shell'"
  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    laptop_step_exec sudo chsh -s "/bin/$target_shell"
  fi
}
