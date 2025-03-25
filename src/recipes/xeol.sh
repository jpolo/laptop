#!/usr/bin/env bash

#
# Install xeol on your project / docker container. This script will install xeol on your system using the package manager you have selected.
#
# @see https://github.com/xeol-io/xeol
#
laptop::ensure_package__xeol() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # xeol is now in the main repo
    # laptop::ensure_brew_tap "xeol-io/xeol"
    laptop::ensure_package_default "xeol"
  else
    laptop::ensure_package_default "xeol"
  fi
}
