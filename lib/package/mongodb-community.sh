#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"
laptop_require "laptop_brew_ensure_package"

laptop_package_ensure__mongodb-community() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "mongodb/brew/mongodb-community@6.0" "$@"
  else
    laptop_package_ensure_default "mongodb-community" "$@"
  fi
}
