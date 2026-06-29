#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_log"

# Execute a command and display the output
#
# Usage:
#   laptop_step_exec <command> <args...>
#
laptop_step_exec() {
  local output
  output=$("$@" 2>&1)
  local exit_code=$?

  if [ "$exit_code" = "0" ]; then
    laptop_step_status "ok"
  else
    laptop_step_status "fail"
    laptop_log error "Command failed \
      \\n|  > $* \
      \\n|  $output"
  fi
}
