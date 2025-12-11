#!/usr/bin/env bash

laptop_require "laptop_vscode_ensure_extension"
laptop_require "laptop_log"

# Install all npm packages from "Codefile" like file
#
# Usage:
#   laptop_vscode_ensure_extension_list <vscode_file>
#
laptop_vscode_ensure_extension_list() {
  local vscode_file="$1"
  local target_extension

  # Check if the file exists
  if [[ -f "$vscode_file" ]]; then
    # Read the file line by line
    while IFS= read -r line; do
      target_extension="$line"

      # If the language matches, return the version
      laptop_vscode_ensure_extension "$target_extension"
    done <"$vscode_file"
  else
    laptop_log warn "$vscode_file does not exist"
  fi
}
