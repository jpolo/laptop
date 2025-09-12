#!/usr/bin/env bash

laptop_ensure_package__libyaml() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_package_default "libyaml"
  else
    laptop_ensure_package_default "libyaml-dev"
  fi
}
