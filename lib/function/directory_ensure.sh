#!/usr/bin/env bash

# Ensure that a directory exists, creating parent directories as needed.
#
# Usage:
#   laptop_directory_ensure <directory_path> [--status present|absent] [--mode <mode>]
#
# Options:
#   --status present|absent
#   --mode mode
#
laptop_directory_ensure() {
  local directory="$1"
  # parse options
  local resource_status="present"
  local mode=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    -m | --mode)
      mode="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done
  local current_resource_status
  current_resource_status=$(test -d "$directory" && echo "present" || echo "absent")
  local message
  message="Directory '$(laptop_path_print "$directory")'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
  if [ "$resource_status" = "present" ]; then
    if [ ! -d "$directory" ]; then
      # if mode is set, run chmod
      local command_script
      command_script="mkdir -p $(quote "$directory")"
      if [ ! -z "$mode" ]; then
        command_script+=" && chmod $mode $(quote "$directory")"
      fi
      laptop_step_eval "$command_script"
    else
      laptop_step_ok
    fi
  else
    laptop_step_eval "rm -rf $(quote "$directory")"
  fi
}
