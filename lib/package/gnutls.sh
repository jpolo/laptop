#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"
laptop_require "laptop_brew_ensure_package"

laptop_package_ensure__gnutls() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "gnutls" "$@"
  else
    laptop_package_ensure_default "gnutls-bin" "$@"
  fi
}
