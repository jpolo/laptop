#!/usr/bin/env bash


# Display a step as OK
#
# Usage:
#   laptop_step_ok
#
laptop_step_ok() {
  echo -e "${_LAPTOP_SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
  return 0
}
