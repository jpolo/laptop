#!/usr/bin/env bash

laptop_require "laptop_self_state_ensure"
laptop_require "laptop_date_now"

# Mark the command as completed
#
# Usage:
#   laptop_self_command_touch <command>
#
laptop_self_command_touch() {
  local command="$1"

  laptop_self_state_ensure "${command}_last_completed_at" "$(laptop_date_now)"
}
