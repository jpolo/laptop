#!/usr/bin/env bash

laptop_package_ensure__mongodb-community() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_tap "mongodb/brew"
    laptop_brew_ensure_package "mongodb-community@6.0"
  else
    laptop_package_ensure_default "mongodb-community"
  fi
}
