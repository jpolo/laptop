#!/usr/bin/env bash

ensure_package__gnutls() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "gnutls"
  else
    ensure_package_default "gnutls-bin"
  fi
}
