#!/usr/bin/env bash

laptop::ensure_package__mongodb-community() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    laptop::ensure_brew_tap "mongodb/brew"
    laptop::ensure_package_default "mongodb-community@6.0"
  else
    laptop::ensure_package_default "mongodb-community"
  fi
}
