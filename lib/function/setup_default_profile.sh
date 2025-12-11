#!/usr/bin/env bash

laptop_require "laptop_die"
laptop_require "laptop_file_ensure"
laptop_require "laptop_ini_ensure"
laptop_require "laptop_ini_get"

# Configure default profile from LAPTOP_PROFILE if not set
#
# Usage:
#   laptop_setup_default_profile
#
laptop_setup_default_profile() {
  # Ensure profile is set
  if [ -z "$(laptop_ini_get "$LAPTOP_USER_CONFIG_FILE" "profile")" ]; then
    if [ -z "$LAPTOP_PROFILE" ]; then
      laptop_die "LAPTOP_PROFILE is not set"
    fi
    laptop_file_ensure "$LAPTOP_USER_CONFIG_FILE"
    laptop_ini_ensure "$LAPTOP_USER_CONFIG_FILE" "profile" "$LAPTOP_PROFILE"
  fi
}
