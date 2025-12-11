#!/usr/bin/env bash

laptop_require "laptop_step_start"

# Display a step with a target status
#
# Usage:
#   laptop_step_start_status <target_status> <current_status> <message>
#
# Options:
#   <current_status> present|absent
#   <target_status> present|absent
laptop_step_start_status() {
  local target_status="$1"
  local current_status="$2"
  local message="$3"
  local color
  if [ "$current_status" = "$target_status" ] && [ "$current_status" != "unknown" ]; then
    color="${DIM}"
  fi

  local status_message
  if [ "$target_status" = "absent" ]; then
    color="${color:-$COLOR_ERROR}" # delete action
    status_message="${color}-${NORMAL}"
  else
    color="${color:-$COLOR_SUCCESS}" # create action
    status_message="${color}+${NORMAL}"
  fi

  laptop_step_start "${status_message} $message"
}
