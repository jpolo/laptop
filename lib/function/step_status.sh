#!/usr/bin/env bash

laptop_require "laptop_die"
laptop_require "laptop_color_intent"
laptop_require "laptop_ansi"

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
      color="$(laptop_ansi bold)$(laptop_color_intent success)"
      message=" OK "
      ;;
    "fail")
      color="$(laptop_ansi bold)$(laptop_color_intent fail)"
      message="FAIL"
      ;;
    "pass")
      color="$(laptop_color_intent dim)"
      message="PASS"
      ;;
    *)
      color="$(laptop_color_intent reset)"
      message=" ?? "
      ;;
  esac
  local color_bracket
  color_bracket="$(laptop_ansi bold)$(laptop_ansi blue)"

  # make sure the message has always same length by adding spaces at start and end
  echo -e "${_LAPTOP_SET_COL}${color_bracket}[${color} ${message} ${NORMAL}${color_bracket}]${NORMAL}"
  return 0
}
