#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"
laptop_require "laptop_path_print"

# Move a file from source to target, creating parent directories as needed.
#
# Usage:
#   laptop_file_moved <source> <target>
#
laptop_file_moved() {
  local source="$1"
  local target="$2"
  local message
  message="Moved '$(laptop_path_print "$source")' > '$(laptop_path_print "$target")'"

  if [ -f "$source" ]; then
    laptop_step_start_status "present" "absent" "$message"
    if [ -f "$target" ]; then
      laptop_step_eval "laptop_die 'Target file $(quote "$target") already exists.'"
    else
      laptop_step_eval "mkdir -p $(quote "$(dirname "$target")") && mv $(quote "$source") $(quote "$target")"
    fi
  else
    laptop_step_start_status "present" "present" "$message"
    laptop_step_status "pass"
  fi
}
