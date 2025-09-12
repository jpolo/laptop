#!/usr/bin/env bash

laptop_ensure_package__mongodb-database-tools() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_tap "mongodb/brew"
    laptop_ensure_package_default "mongodb-database-tools"
  else
    laptop_ensure_package_default "mongodb-database-tools"
  fi
}
