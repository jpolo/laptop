#!/usr/bin/env bash

laptop_require "laptop_log"
laptop_require "laptop_self_updated"

# Check if laptop is up to date
#
# Usage:
#   laptop_self_check_version
#
laptop_self_check_version() {
  if laptop_self_updated; then
    laptop_log info "Laptop is up to date"
  else
    laptop_log warn "A new laptop version is available. Run 'laptop self-upgrade' to download it."
  fi
}
