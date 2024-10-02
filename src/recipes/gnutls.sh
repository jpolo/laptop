#!/usr/bin/env bash

laptop::ensure_package__gnutls() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    laptop::ensure_package_default "gnutls"
  else
    laptop::ensure_package_default "gnutls-bin"
  fi
}
