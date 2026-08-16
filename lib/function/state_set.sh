#!/usr/bin/env bash

laptop_require "laptop_file_var_set"

# Set a value in the laptop state file.
#
# Usage:
#   laptop_state_set <key> <value>
#
laptop_state_set() {
  local key="$1"
  local value="$2"
  local state_file="$LAPTOP_USER_STATE_DIR/state.ini"

  mkdir -p "$LAPTOP_USER_STATE_DIR"
  laptop_file_var_set "$state_file" "$key" "$value"
}
