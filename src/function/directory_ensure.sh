#!/usr/bin/env bash

# Ensure that a directory exists, creating parent directories as needed.
#
# Usage:
#   laptop_directory_ensure <directory_path> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_directory_ensure() {
  local directory="$1"
  # parse options
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  laptop_step_start_status "$resource_status" "Directory '$(laptop_path_print "$directory")'"
  if [ "$resource_status" = "present" ]; then
    if [ ! -d "$directory" ]; then
      laptop_step_eval "mkdir -p $(quote "$directory")"
    else
      laptop_step_ok
    fi
  else
    laptop_step_eval "rm -rf $(quote "$directory")"
  fi
}
