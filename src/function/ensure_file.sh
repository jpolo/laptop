#!/usr/bin/env bash

laptop_ensure_file() {
  local file_path="$1"
  laptop_step_start "- Ensure file '$file_path'"

  laptop_step_eval "\
    mkdir -p $(quote "$(dirname "$file_path")") && \
    touch $(quote "$file_path")
    "
}
