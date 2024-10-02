#!/usr/bin/env bash

laptop::ensure_package__yarn() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    laptop::ensure_package_default "yarn"
  else
    laptop::ensure_apt_repository "https://dl.yarnpkg.com/debian/ stable main" "https://dl.yarnpkg.com/debian/pubkey.gpg"
    laptop::ensure_package_default "yarn"
  fi
}
