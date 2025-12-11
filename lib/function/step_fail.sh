#!/usr/bin/env bash

# Display a step as FAIL
#
# Usage:
#   laptop_step_fail
#
laptop_step_fail() {
  echo -e "${_LAPTOP_SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
  return 0
}
