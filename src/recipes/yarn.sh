#!/usr/bin/env bash

laptop_ensure_package__yarn() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_package_default "yarn"
  else
    laptop_ensure_apt_repository "https://dl.yarnpkg.com/debian/ stable main" "https://dl.yarnpkg.com/debian/pubkey.gpg"
    laptop_ensure_package_default "yarn"
  fi
}
