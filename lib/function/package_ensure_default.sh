#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_apt_ensure_package"
laptop_require "laptop_die"

laptop_package_ensure_default() {
  # Install using package manager
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "$@"
  elif [ "$LAPTOP_PACKAGE_MANAGER" = "apt-get" ]; then
    laptop_apt_ensure_package "$@"
  else
    laptop_die "Unsupported package manager: $LAPTOP_PACKAGE_MANAGER"
  fi
}
