#!/usr/bin/env bash

laptop::ensure_package__heroku() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop::ensure_brew_tap "heroku/brew"
    laptop::ensure_package_default "heroku"
  else
    laptop::ensure_package_default "heroku"
  fi
}
