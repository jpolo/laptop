#!/usr/bin/env bash

laptop::ensure_asdf_tool() {
  local language="$1"
  local version=$2 || "latest"

  laptop::step_start "- Ensure asdf '$language' '$version'"
  if ! asdf list "$language" | grep -Fq "$version"; then
    laptop::step_exec \
      asdf install "$language" "$version" &&
      asdf set --home "$language" "$version"
  else
    laptop::step_exec \
      asdf set --home "$language" "$version"
  fi
}
