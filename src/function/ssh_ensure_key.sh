#!/usr/bin/env bash

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
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  local algorithm
  algorithm=${1:-"ed25519"}
  local ssh_key
  ssh_key="$HOME/.ssh/id_$algorithm"
  local email
  email=$(git config --global user.email)

  laptop_step_start_status "$resource_status" "SSH key '$(laptop_path_print $ssh_key)'"

  if [  "$resource_status" = "present" ]; then
    if [ -z "$email" ]; then
      laptop_step_fail
      laptop_error "git config user.email is empty"
    elif ! [ -f "$ssh_key" ]; then
      laptop_step_exec ssh-keygen -t "$algorithm" -C "$email" -N '' -o -f "$ssh_key"
    else
      laptop_step_ok
    fi
  else
    laptop_ensure_file "$ssh_key" --status absent
  fi
}
