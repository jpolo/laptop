#!/usr/bin/env bash

laptop_package_ensure__gnutls() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_package_ensure_default "gnutls"
  else
    laptop_package_ensure_default "gnutls-bin"
  fi
}
