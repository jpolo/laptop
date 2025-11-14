#!/usr/bin/env bash

laptop_package_ensure__mongodb-database-tools() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_tap "mongodb/brew"
    laptop_brew_ensure_package "mongodb-database-tools"
  else
    laptop_package_ensure_default "mongodb-database-tools"
  fi
}
