#!/usr/bin/env bash

ensure_package__yarn() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "yarn"
  else
    ensure_apt_repository "https://dl.yarnpkg.com/debian/ stable main" "https://dl.yarnpkg.com/debian/pubkey.gpg"
    ensure_package_default "yarn"
  fi
}
