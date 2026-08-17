#!/usr/bin/env bash

laptop_require "laptop_die"
laptop_require "laptop_self_config_get"
laptop_require "laptop_self_config_ensure"

# Configure default profile from LAPTOP_PROFILE if not set
#
# Usage:
#   laptop_setup_default_profile
#
laptop_setup_default_profile() {
  # Ensure profile is set
  if [ -z "$(laptop_self_config_get "profile")" ]; then
    if [ -z "$LAPTOP_PROFILE" ]; then
      laptop_die "LAPTOP_PROFILE is not set"
    fi
    laptop_self_config_ensure "profile" "$LAPTOP_PROFILE"
  fi
}
