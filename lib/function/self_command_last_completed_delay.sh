#!/usr/bin/env bash

laptop_require "laptop_self_config_get"

# Get the last completed timeout of the command
# (e.g., the max delay allowed before the command is considered overdue)
#
# Usage:
#   laptop_self_command_last_completed_delay <command> [<default_delay>]
#
laptop_self_command_last_completed_delay() {
  local command="$1"
  local default_delay="$2"
  local variable_name
  local config_key="${command}_delay"

  # uppercase the command to construct the environment variable name
  # e.g., LAPTOP_SETUP_DELAY, LAPTOP_UPGRADE_DELAY, LAPTOP_CLEANUP_DELAY
  variable_name="LAPTOP_$(echo "$command" | tr '[:lower:]' '[:upper:]')_DELAY"

  local delay="${!variable_name:-$(laptop_self_config_get "$config_key")}"

  if [ -z "$delay" ]; then
    delay="$default_delay"
  fi

  if [[ ! "$delay" =~ ^[0-9]+$ ]]; then
    laptop_die "Invalid delay value for command '$command': '$delay'. Must be a non-negative integer."
  fi

  echo "$delay"
}


