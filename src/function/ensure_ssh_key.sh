#!/usr/bin/env bash

laptop_ensure_ssh_key() {
  local algorithm
  algorithm=${1:-"ed25519"}
  local ssh_key
  ssh_key="$HOME/.ssh/id_$algorithm"
  local email
  email=$(git config --global user.email)

  laptop_step_start "- Ensure SSH key '$ssh_key'"
  if [ -z "$email" ]; then
    laptop_step_fail
    laptop_error "git config user.email is empty"
  elif ! [ -f "$ssh_key" ]; then
    laptop_step_exec ssh-keygen -t "$algorithm" -C "$email" -N '' -o -f "$ssh_key"
  else
    laptop_step_ok
  fi
}
