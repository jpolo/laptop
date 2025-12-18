#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"
laptop_require "laptop_brew_ensure_package"

#
# Install xeol on your project / docker container. This script will install xeol on your system using the package manager you have selected.
#
# @see https://github.com/xeol-io/xeol
#
laptop_package_ensure__xeol() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # xeol is now in the main repo
    # laptop_brew_ensure_tap "xeol-io/xeol"
    laptop_brew_ensure_package "xeol"
  else
    laptop_package_ensure_default "xeol"
  fi
}
