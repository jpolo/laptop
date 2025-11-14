#!/usr/bin/env bash

laptop_directory_ensure_empty() {
  local directory="$1"
  laptop_step_start "- Clean directory $directory"
  laptop_step_eval "if [ -d '$directory' ]; then rm -rfv '$directory'/*; fi"
}
