#!/usr/bin/env bash

laptop_github_ensure_login() {
  laptop_step_start_status "present" "unknown" "Github account logged in"
  if ! gh auth status -h github.com &>/dev/null; then
    if gh auth login -p ssh -h github.com -w && eval "$(ssh-agent -s)"; then
      laptop_step_ok
    else
      laptop_step_fail
    fi
  else
    laptop_step_ok
  fi
}
