#!/usr/bin/env bash

laptop_package_ensure__libpq() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "libpq"
    laptop_brew_ensure_link "libpq"
  else
    laptop_package_ensure_default "libpq-dev"
  fi
}
