#!/usr/bin/env bash

laptop_step_start() {
  echo -n -e "${@}"
  return 0
}

laptop_step_ok() {
  # echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
  return 0
}

laptop_step_fail() {
  # echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
  return 0
}

laptop_step_pass() {
  #echo -n -e "${@}"
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
