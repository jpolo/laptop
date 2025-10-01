#!/usr/bin/env bash

laptop_step_start() {
  local message="$1"
  # display the message and truncate the line to $COLUMNS characters
  # and adds a ... at the end if truncated
  if [ "${#message}" -ge "$LAPTOP_STEP_STATUS_COLUMN" ]; then
    message="${message:0:$LAPTOP_STEP_STATUS_COLUMN-5}..."
  fi
  echo -n -e "$message"
  return 0
}

# Display a step with a target status
#
# Usage:
#   laptop_step_start_status <target_status> <message>
#
# Options:
#   <target_status> present|absent
laptop_step_start_status() {
  local target_status="$1"
  local message="$2"
  # display A if present, F if failed
  local status_message="${COLOR_SUCCESS}+${NORMAL}"
  if [ "$target_status" = "absent" ]; then
    status_message="${COLOR_ERROR}-${NORMAL}"
  fi
  laptop_step_start "${status_message} $message"
}

laptop_step_ok() {
  echo -e "${SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
  return 0
}

laptop_step_fail() {
  echo -e "${SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
  return 0
}

laptop_step_pass() {
  echo -e "${SET_COL}${BRACKET}[${NORMAL} PASS ${BRACKET}]${NORMAL}"
  return 0
}

laptop_step_complete() {
  local command=$1
  local exit_code=$2
  local output=$3

  if [ "$exit_code" = "0" ]; then
    laptop_step_ok
  else
    laptop_step_fail
    laptop_error "Command failed \
      \\n|  > $command \
      \\n|  $output"
  fi
}

laptop_step_exec() {
  laptop_step_eval "$*"
}

laptop_step_eval() {
  local output
  local command="$1"
  output=$(eval "$command" 2>&1)
  local exit_code=$?

  laptop_step_complete "$command" "$exit_code" "$output"
}
