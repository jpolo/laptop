#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_step_start"
laptop_require "laptop_step_status"
laptop_require "laptop_step_eval"

laptop_package_ensure__heroku() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # INFO: heroku is now in the main the repo
    # laptop_brew_ensure_tap "heroku/brew"
    laptop_brew_ensure_package "heroku"
  else
    laptop_step_start "- Ensure apt package 'heroku'"
    if dpkg -s "heroku" &>/dev/null; then
      laptop_step_status "ok"
    else
      laptop_step_eval "curl https://cli-assets.heroku.com/install-ubuntu.sh | sh"
    fi
  fi
}
