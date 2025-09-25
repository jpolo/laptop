#!/usr/bin/env bash

# Print a file path replacing home directory with ~
#
# Usage:
#   laptop_path_print <file_path>
laptop_path_print() {
  local file_path="$1"
  # replace home directory with ~
  echo "${file_path/#$HOME/~}"
}
