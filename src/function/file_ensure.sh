#!/usr/bin/env bash

laptop_file_ensure() {
  local file_path="$1"
  laptop_step_start "- Ensure file '$file_path'"

  laptop_step_eval "\
    mkdir -p $(quote "$(dirname "$file_path")") && \
    touch $(quote "$file_path")
    "
}
