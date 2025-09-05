#!/usr/bin/env bash

# Install asdf plugin `name` if not present
#
# Usage:
#   laptop::ensure_asdf_plugin <name> <url>
#
laptop::ensure_asdf_plugin() {
  local name="$1"
  local url="$2"
  laptop::step_start "- Ensure asdf plugin '$name'"

  if ! asdf plugin list | grep -Fq "$name"; then
    laptop::step_exec asdf plugin add "$name" "$url"
  else
    laptop::step_ok
  fi
}
