#!/usr/bin/env bash

laptop::ensure_npm_package() {
  local package="$1"

  laptop::step_start "- Ensure NPM package '$package'"
  local npm_args=("--quiet --global")

  if [ -n "$(npm list --global --parseable "$package")" ]; then
    laptop::step_ok
  else
    laptop::step_eval "npm install ${npm_args[@]} $(quote "$package")"
  fi
}
