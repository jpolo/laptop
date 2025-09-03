#!/usr/bin/env bash

laptop::ensure_github_login() {
  laptop::step_start "- Ensure Github logged in"
  if ! gh auth status -h github.com &>/dev/null; then
    gh auth login -p ssh -h github.com -w \
      && eval "$(ssh-agent -s)" \
      && laptop::step_ok || laptop::step_fail
  else
    laptop::step_ok
  fi
}
