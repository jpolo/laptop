#!/usr/bin/env bash

laptop_ensure_package__libpq() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_package "libpq"
    laptop_ensure_brew_link "libpq"
  else
    laptop_ensure_package_default "libpq-dev"
  fi
}
