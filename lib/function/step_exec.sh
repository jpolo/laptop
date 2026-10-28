#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_log"

# Execute a command and display the output
#
# Usage:
#   laptop_step_exec <command> <args...>
#   laptop_step_exec --interactive -- <command> <args...>
#
# Options:
#   --interactive  Attach stdin/stdout/stderr to the terminal. Use for
#                  interactive commands (device-code login, prompts) whose
#                  output must stay visible. Capturing it hides the prompt
#                  and the command looks stuck.
#
laptop_step_exec() {
  local interactive=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --interactive)
      interactive=1
      shift
      ;;
    --)
      shift
      break
      ;;
    *) break ;;
    esac
  done

  local exit_code=0
  if [ "$interactive" = "1" ]; then
    # Close the pending step line so command output starts on its own line.
    echo ""
    "$@" || exit_code=$?
  else
    local output
    output=$("$@" 2>&1)
    exit_code=$?
  fi

  if [ "$exit_code" = "0" ]; then
    laptop_step_status "ok"
  else
    laptop_step_status "fail"
    if [ "$interactive" != "1" ]; then
      laptop_log error "Command failed \
      \\n|  > $* \
      \\n|  $output"
    fi
  fi
}
