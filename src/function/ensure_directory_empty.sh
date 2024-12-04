#!/usr/bin/env bash

laptop::ensure_directory_empty() {
  local directory="$1"
  laptop::step_start "- Clean directory $directory"
  laptop::step_eval "if [ -d '$directory' ]; then rm -rfv '$directory'/*; fi"
}
