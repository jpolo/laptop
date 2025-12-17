#!/usr/bin/env bash

laptop_require "laptop_die"

# Display a step as OK
#
# Usage:
#   laptop_step_status <status>
#
# Status:
#   - ok: OK
#   - fail: FAIL
#   - pass: PASS
laptop_step_status() {
  local step_status="$1"
  local color
  # uppercase the status
  local message
  message=$(echo "$step_status" | tr '[:lower:]' '[:upper:]')
  case "$step_status" in
    "ok")
      color="${SUCCESS}"
      message=" OK "
      ;;
    "fail")
      color="${FAILURE}"
      message="FAIL"
      ;;
    "pass")
      color="${DIM}"
      message="PASS"
      ;;
    *)
      color="${NORMAL}"
      message=" ?? "
      ;;
  esac

  # make sure the message has always same length by adding spaces at start and end
  echo -e "${_LAPTOP_SET_COL}${BRACKET}[${color} ${message} ${NORMAL}${BRACKET}]${NORMAL}"
  return 0
}
