#!/usr/bin/env bash

# Install asdf plugin `name` if not present
#
# Usage:
#   laptop_ensure_asdf_plugin <name> <url>
#
laptop_ensure_asdf_plugin() {
  local name="$1"
  local url="$2"
  laptop_step_start "- Ensure asdf plugin '$name'"

  if ! asdf plugin list | grep -Fq "$name"; then
    laptop_step_exec asdf plugin add "$name" "$url"
  else
    laptop_step_ok
  fi
}
