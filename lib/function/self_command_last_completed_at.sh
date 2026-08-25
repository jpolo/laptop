#!/usr/bin/env bash

laptop_require "laptop_self_state_get"

# Get the last completed timestamp of the command
#
# Usage:
#   laptop_self_command_last_completed_at <command>
#
laptop_self_command_last_completed_at() {
  local command="$1"

  laptop_self_state_get "${command}_last_completed_at"
}


