#!/usr/bin/env bash

laptop::ensure_package__libpq() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop::ensure_brew_package "libpq"
    laptop::ensure_brew_link "libpq"
  else
    laptop::ensure_package_default "libpq-dev"
  fi
}
