#!/usr/bin/env bash

laptop_package_ensure__augeas() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "augeas"
  else
    laptop_package_ensure_default "augeas-tools"
  fi
}
