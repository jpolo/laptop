#!/usr/bin/env bash

laptop_require "laptop_step_start_status"

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

  _laptop_step_complete "$command" "$exit_code" "$output"
}


_laptop_step_complete() {
  local command=$1
  local exit_code=$2
  local output=$3

  if [ "$exit_code" = "0" ]; then
    laptop_step_status "ok"
  else
    laptop_step_status "fail"
    laptop_error "Command failed \
      \\n|  > $command \
      \\n|  $output"
  fi
}
