#!/usr/bin/env bash

laptop_require "laptop_file_var_get"

# Get a value from the laptop state file.
#
# Usage:
#   laptop_state_get <key>
#
laptop_state_get() {
  local key="$1"
  local state_file="$LAPTOP_USER_STATE_DIR/state"

  if [ ! -f "$state_file" ]; then
    echo ""
    return
  fi

  laptop_file_var_get "$state_file" "$key"
}
