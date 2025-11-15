#!/usr/bin/env bash

# Install all asdf packages from ".tool-versions" like file
#
# Usage:
#   laptop_asdf_ensure_package_list <tool_version_file>
#
laptop_asdf_ensure_package_list() {
  local tool_version_file="$1"
  local target_package
  local target_version

  # Check if the file exists
  if [[ -f "$tool_version_file" ]]; then
    # Read the file line by line
    while IFS= read -r line; do
      # Split the line into language and version
      target_package=$(echo "$line" | awk '{print $1}')
      target_version=$(echo "$line" | awk '{print $2}')

      # If the language matches, return the version
      laptop_asdf_ensure_package "$target_package" "$target_version"
    done <"$tool_version_file"
  else
    laptop_warn "$tool_version_file does not exist"
  fi
}
