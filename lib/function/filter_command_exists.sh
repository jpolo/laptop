#!/usr/bin/env bash

# Filter array keeping only available commands
#
# Example 1 :
#   laptop_filter_command_exists "brew" "npm" "yarn"
#   > "brew" "npm"
#
laptop_filter_command_exists() {
  local filtered_array=()
  for tool in "$@"; do
    if laptop_command_exists "$tool"; then
      filtered_array+=("$tool")
    fi
  done
  echo "${filtered_array[@]}"
}
