#!/usr/bin/env bash

laptop_require "laptop_step_start"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

# Install brew autoupdate if not present
#
# Usage:
#   laptop_brew_ensure_autoupdate [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_brew_ensure_autoupdate() {
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
  local brew_auto_update_present
  brew_auto_update_present=$(env -i zsh --login -c 'brew autoupdate status &>/dev/null;echo $?')

  if [ "$brew_auto_update_present" != "0" ]; then
    brew tap homebrew/autoupdate
  fi

  local current_resource_status
  current_resource_status=$(brew autoupdate status | grep --quiet running && echo "present" || echo "absent")

  laptop_step_start_status "$resource_status" "$current_resource_status" "brew autoupdate"
  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec brew autoupdate start
    else
      laptop_step_exec brew autoupdate stop
    fi
  fi
}
