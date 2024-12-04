#!/usr/bin/env bash

laptop::source_all() {
  local script_dir="$1"
  for file in $(find "$script_dir" -type f -maxdepth 1 -name '*.sh' -print); do
    source $file;
  done
}
