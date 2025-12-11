#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_step_exec"

# Ensure Github account is logged in
# See gh auth --help for more information
#
# Usage:
#   laptop_github_ensure_login [--host <host>] [--scopes <scopes>]
#
# Options:
#   --host <host>
#   --scopes <scopes>
#
laptop_github_ensure_login() {
  local host="github.com"
  local scopes="gist, read:org, repo"
  local resource_status="present"
  local resource_current_status

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --host)
      host="$2"
      shift 2
      ;;
    -s | --scopes)
      scopes="$scopes,$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  resource_current_status=$(gh auth status -h "$host" &>/dev/null && echo "present" || echo "absent")

  laptop_step_start_status "$resource_status" "$resource_current_status" "Github account logged in"
  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if gh auth login -p ssh -h "$host" --scopes "$scopes" -w && eval "$(ssh-agent -s)"; then
      laptop_step_status "ok"
    else
      laptop_step_status "fail"
    fi
  fi
}
