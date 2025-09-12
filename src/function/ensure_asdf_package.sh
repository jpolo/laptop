#!/usr/bin/env bash

# Install asdf `package` if not present
#
# Usage:
#   laptop_ensure_asdf_package <package> <version>
#
laptop_ensure_asdf_package() {
  local package="$1"
  local version="${2:-latest}"

  laptop_step_start "- Ensure asdf '$package' '$version'"
  if ! asdf list "$package" 2>/dev/null | grep -Fq "$version"; then
    laptop_step_exec \
      asdf install "$package" "$version" &&
      asdf set --home "$package" "$version"
  else
    laptop_step_exec \
      asdf set --home "$package" "$version"
  fi
}
