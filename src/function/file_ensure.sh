#!/usr/bin/env bash

# Ensure that a file exists, creating parent directories as needed.
#
# Usage:
#   laptop_file_ensure <file_path>
laptop_file_ensure() {
  local file_path="$1"
  laptop_step_start "- Ensure file '$(laptop_path_print "$file_path")'"

  laptop_step_eval "\
    mkdir -p $(quote "$(dirname "$file_path")") && \
    touch $(quote "$file_path")
    "
}
