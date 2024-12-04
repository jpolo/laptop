#!/usr/bin/env bash

laptop::ensure_file() {
  local file_path="$1"
  laptop::step_start "- Ensure file '$file_path'"

  laptop::step_eval "\
    mkdir -p $(quote "$(dirname "$file_path")") && \
    touch $(quote "$file_path")
    "
}
