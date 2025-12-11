#!/usr/bin/env bash

laptop_github_ensure_login() {
  local resource_status="present"
  local resource_current_status
  resource_current_status=$(gh auth status -h github.com &>/dev/null && echo "present" || echo "absent")

  laptop_step_start_status "$resource_status" "$resource_current_status" "Github account logged in"
  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if gh auth login -p ssh -h github.com -w && eval "$(ssh-agent -s)"; then
      laptop_step_status "ok"
    else
      laptop_step_status "fail"
    fi
  fi
}
