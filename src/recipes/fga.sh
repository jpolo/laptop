#!/usr/bin/env bash

laptop_package_ensure__fga() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "openfga/tap/fga"
  else
    laptop_package_ensure_default "fga"
  fi
}
