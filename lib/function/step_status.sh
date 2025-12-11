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
  local status="$1"
  local color
  # uppercase the status
  local message
  message=$(echo "$status" | tr '[:lower:]' '[:upper:]')
  case "$status" in
    "ok")
      color="${SUCCESS}"
      ;;
    "fail")
      color="${FAILURE}"
      ;;
    *)
      color="${NORMAL}"
      ;;
  esac

  echo -e "${_LAPTOP_SET_COL}${BRACKET}[${color} ${message} ${BRACKET}]${NORMAL}"
  return 0
}
