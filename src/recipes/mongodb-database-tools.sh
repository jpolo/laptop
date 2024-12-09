#!/usr/bin/env bash

laptop::ensure_package__mongodb-database-tools() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop::ensure_brew_tap "mongodb/brew"
    laptop::ensure_package_default "mongodb-database-tools"
  else
    laptop::ensure_package_default "mongodb-database-tools"
  fi
}
