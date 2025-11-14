#!/usr/bin/env bash

laptop_source_all() {
  local script_dir="$1"
  # shellcheck disable=SC2044
  for file in $(find "$script_dir" -maxdepth 1 -type f -name '*.sh' -print); do
    # shellcheck disable=SC1090
    source "$file"
  done
}
