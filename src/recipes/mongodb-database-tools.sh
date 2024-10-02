#!/usr/bin/env bash

ensure_package__mongodb-database-tools() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "mongodb/brew"
    ensure_package_default "mongodb-database-tools"
  else
    ensure_package_default "mongodb-database-tools"
  fi
}
