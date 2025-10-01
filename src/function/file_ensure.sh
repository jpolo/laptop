#!/usr/bin/env bash

# Ensure that a file exists, creating parent directories as needed.
#
# Usage:
#   laptop_file_ensure <file_path> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_file_ensure() {
  local file_path="$1"
  # parse options
  local package_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) package_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  laptop_step_start "- Ensure file '$(laptop_path_print "$file_path")' is $package_status"

  if [ "$package_status" = "present" ]; then
    laptop_step_eval "\
    mkdir -p $(quote "$(dirname "$file_path")") && \
    touch $(quote "$file_path")
    "
  else
    laptop_step_eval "rm -f $(quote "$file_path")"
  fi
}
