#!/usr/bin/env bash

laptop::ensure_package__heroku() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # INFO: heroku is now in the main the repo
    # laptop::ensure_brew_tap "heroku/brew"
    laptop::ensure_package_default "heroku"
  else
    laptop::step_start "- Ensure apt package 'heroku'"
    if dpkg -s "heroku" &>/dev/null; then
      laptop::step_ok
    else
      laptop::step_eval "curl https://cli-assets.heroku.com/install-ubuntu.sh | sh"
    fi
  fi
}
