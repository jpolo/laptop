#!/usr/bin/env bash

laptop::ensure_package__libpq() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop::ensure_package_default "libpq"
  else
    laptop::ensure_package_default "libpq-dev"
  fi
}
