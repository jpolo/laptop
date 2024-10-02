#!/usr/bin/env bash

ensure_package__mongodb-community() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "mongodb/brew"
    ensure_package_default "mongodb-community@6.0"
  else
    ensure_package_default "mongodb-community"
  fi
}
