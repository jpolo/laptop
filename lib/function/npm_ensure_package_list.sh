#!/usr/bin/env bash

laptop_require "laptop_npm_ensure_package"
laptop_require "laptop_log"

# Install all npm packages from "npmfile" like file
#
# Usage:
#   laptop_npm_ensure_package_list <npm_file>
#
laptop_npm_ensure_package_list() {
  local npm_file="$1"
  local target_package

  # Check if the file exists
  if [[ -f "$npm_file" ]]; then
    # Read the file line by line
    while IFS= read -r line; do
      target_package="$line"

      # If the language matches, return the version
      laptop_npm_ensure_package "$target_package"
    done <"$npm_file"
  else
    laptop_log warn "$npm_file does not exist"
  fi
}
