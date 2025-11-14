#!/usr/bin/env bash

laptop_package_ensure__libyaml() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_package_ensure_default "libyaml"
  else
    laptop_package_ensure_default "libyaml-dev"
  fi
}
