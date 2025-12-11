#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"
laptop_require "laptop_log"
laptop_require "laptop_path_print"

# Ensure SSH key exists
#
# Usage:
#   laptop_ssh_ensure_key [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_ssh_ensure_key() {
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done
  local algorithm
  algorithm=${1:-"ed25519"}
  local ssh_key
  ssh_key="$HOME/.ssh/id_$algorithm"
  local email
  email=$(git config --global user.email)

  local current_resource_status
  current_resource_status=$(test -f "$ssh_key" && echo "present" || echo "absent")
  local message
  message="SSH key '$(laptop_path_print "$ssh_key")'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      if [ -z "$email" ]; then
        laptop_step_status "fail"
        laptop_log error "git config user.email is empty"
      else
        laptop_step_exec ssh-keygen -t "$algorithm" -C "$email" -N '' -o -f "$ssh_key"
      fi
    else
      laptop_step_exec rm -f "$ssh_key"
    fi
  fi
}
