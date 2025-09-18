#!/usr/bin/env bash

laptop_ensure_package__fga() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_package "openfga/tap/fga"
  else
    laptop_ensure_package_default "fga"
  fi
}
