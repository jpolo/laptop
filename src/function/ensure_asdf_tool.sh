#!/usr/bin/env bash

laptop::ensure_asdf_tool() {
  local language="$1"
  local version=$2 || "latest"

  laptop::step_start "- Ensure asdf '$language' '$version'"
  if ! asdf list "$language" | grep -Fq "$version"; then
    laptop::step_exec \
      asdf install "$language" "$version" && \
      asdf global "$language" "$version"
  else
    laptop::step_exec \
      asdf global "$language" "$version"
  fi
}
