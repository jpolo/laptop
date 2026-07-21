#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_package_ensure_default"

laptop_package_ensure__atlassian-cli() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # Atlassian CLI
    laptop_brew_ensure_package "atlassian/homebrew-acli/acli" "$@"
  else
    laptop_package_ensure_default "acli" "$@"
  fi
}
