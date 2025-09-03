#!/usr/bin/env bash

laptop::ensure_github_login() {
  laptop::step_start "- Ensure Github logged in"
  if ! gh auth status -h github.com &>/dev/null; then
    if gh auth login -p ssh -h github.com -w && eval "$(ssh-agent -s)"; then
      laptop::step_ok
    else
      laptop::step_fail
    fi
  else
    laptop::step_ok
  fi
}
