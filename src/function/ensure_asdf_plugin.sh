#!/usr/bin/env bash

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
