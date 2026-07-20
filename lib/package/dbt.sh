#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_package_ensure_default"

laptop_package_ensure__dbt() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # dbt proprietary CLI
    laptop_brew_ensure_package "dbt-labs/dbt/dbt" "$@"
  else
    laptop_package_ensure_default "dbt" "$@"
  fi
}
