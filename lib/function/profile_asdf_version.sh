#!/usr/bin/env bash

# Retrieves the version of a specified language from the .tool-versions file
# in the current profile directory.
#
# Usage:
#   laptop_profile_asdf_version <language>
#
# Example:
#   version=$(laptop_profile_asdf_version "nodejs")
laptop_profile_asdf_version() {
  local language="$1"

  # Path to the .tool-versions file
  local tool_versions_file
  tool_versions_file="$(laptop_profile_dir)/.tool-versions"

  local target_language
  local target_version

  # Check if the file exists
  if [[ -f "$tool_versions_file" ]]; then
    # Read the file line by line
    while IFS= read -r line; do
      # Split the line into language and version
      target_language=$(echo "$line" | awk '{print $1}')
      target_version=$(echo "$line" | awk '{print $2}')

      # If the language matches, return the version
      if [[ "$target_language" == "$language" ]]; then
        echo "$target_version"
        return 0
      fi
    done <"$tool_versions_file"
  fi
}
