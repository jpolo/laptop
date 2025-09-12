#!/usr/bin/env bash

laptop_ensure_package__gnutls() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_package_default "gnutls"
  else
    laptop_ensure_package_default "gnutls-bin"
  fi
}
