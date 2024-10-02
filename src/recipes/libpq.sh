#!/usr/bin/env bash

ensure_package__libpq() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "libpq"
  else
    ensure_package_default "libpq-dev"
  fi
}
