#!/usr/bin/env bash

laptop_npm_ensure_package() {
  local package="$1"

  laptop_step_start "- Ensure NPM package '$package'"

  if [ -n "$(npm list --global --parseable "$package")" ]; then
    laptop_step_ok
  else
    laptop_step_eval "npm install --quiet --global $(quote "$package")"
  fi
}
