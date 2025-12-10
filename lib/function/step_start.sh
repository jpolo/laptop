#!/usr/bin/env bash

# Display a step
#
# Usage:
#   laptop_step_start <message>
#
laptop_step_start() {
  local message="$1"
  # display the message and truncate the line to $COLUMNS characters
  # and adds a ... at the end if truncated
  if [ "${#message}" -ge "$_LAPTOP_STEP_STATUS_COLUMN" ]; then
    message="${message:0:$_LAPTOP_STEP_STATUS_COLUMN-5}..."
  fi
  echo -n -e "$message"
  return 0
}
