#!/usr/bin/env bash

# Install asdf `package` if not present
#
# Usage:
#   laptop::ensure_asdf_tool <package> <version>
#
laptop::ensure_asdf_tool() {
  local package="$1"
  local version="${2:-latest}"

  laptop::step_start "- Ensure asdf '$package' '$version'"
  if ! asdf list "$package" | grep -Fq "$version"; then
    laptop::step_exec \
      asdf install "$package" "$version" &&
      asdf set --home "$package" "$version"
  else
    laptop::step_exec \
      asdf set --home "$package" "$version"
  fi
}
