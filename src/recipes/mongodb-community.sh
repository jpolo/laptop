#!/usr/bin/env bash

laptop_ensure_package__mongodb-community() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_tap "mongodb/brew"
    laptop_ensure_package_default "mongodb-community@6.0"
  else
    laptop_ensure_package_default "mongodb-community"
  fi
}
