#!/usr/bin/env bash

ensure_package__heroku() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "heroku/brew"
    ensure_package_default "heroku"
  else
    ensure_package_default "heroku"
  fi
}
