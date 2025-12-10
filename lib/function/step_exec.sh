#!/usr/bin/env bash

laptop_require "laptop_step_eval"

# Execute a command and display the output
#
# Usage:
#   laptop_step_exec <command> <args...>
#
laptop_step_exec() {
  laptop_step_eval "$*"
}
