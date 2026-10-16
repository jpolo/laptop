#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"

laptop_mise_ensure_package() {
  local package="$1"
  local version="$2"
  local message="mise '$package' '$version'"

  laptop_step_start_status "present" "unknown" "$message"
  if mise use --global "$package@$version"; then
    laptop_step_status "ok"
  else
    laptop_step_status "fail"
    return 1
  fi
}
