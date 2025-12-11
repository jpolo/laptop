#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_log"

# Execute a command and display the output
#
# Usage:
#   laptop_step_eval <command>
#
laptop_step_eval() {
  local output
  local command="$1"
  output=$(eval "$command" 2>&1)
  local exit_code=$?

  if [ "$exit_code" = "0" ]; then
    laptop_step_status "ok"
  else
    laptop_step_status "fail"
    laptop_log error "Command failed \
      \\n|  > $command \
      \\n|  $output"
  fi
}
