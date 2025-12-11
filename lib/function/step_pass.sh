#!/usr/bin/env bash

# Display a step as PASS
#
# Usage:
#   laptop_step_pass
#
laptop_step_pass() {
  echo -e "${_LAPTOP_SET_COL}${BRACKET}[${NORMAL} PASS ${BRACKET}]${NORMAL}"
  return 0
}
