#!/usr/bin/env bash

laptop_require "laptop_log"

# Call a handler function
#
# The handler function must be named like this:
#    laptop_handler__<command>
#
# Usage:
#   laptop_handler_call <command> <args...>
#
laptop_handler_call() {
  local command="$1"
  shift
  local function_name="laptop_handler__${command}"
  if declare -f "$function_name" >/dev/null; then
    "$function_name" "$@"
  else
    laptop_log error "No handler function '$function_name'"
    return 1
  fi
}
