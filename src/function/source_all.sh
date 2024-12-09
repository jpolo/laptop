#!/usr/bin/env bash

laptop::source_all() {
  local script_dir="$1"
  # shellcheck disable=SC2044
  for file in $(find "$script_dir" -type f -maxdepth 1 -name '*.sh' -print); do
    # shellcheck disable=SC1090
    source "$file"
  done
}
