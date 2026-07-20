#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_package_ensure_default"

laptop_package_ensure__dbt-core() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # dbt core open source CLI
    laptop_brew_ensure_package "dbt-labs/dbt/dbt-core" "$@"
  else
    laptop_package_ensure_default "dbt-core" "$@"
  fi
}
