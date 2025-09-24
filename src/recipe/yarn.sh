#!/usr/bin/env bash

laptop_package_ensure__yarn() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_package_ensure_default "yarn"
  else
    laptop_apt_ensure_repository "https://dl.yarnpkg.com/debian/ stable main" "https://dl.yarnpkg.com/debian/pubkey.gpg"
    laptop_package_ensure_default "yarn"
  fi
}
