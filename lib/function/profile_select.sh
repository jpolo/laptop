#!/usr/bin/env bash

laptop_require "laptop_log"
laptop_require "laptop_profile_available"

# Select profile
#
# Usage:
#   laptop_profile_select
#
laptop_profile_select() {
  # Select profile
  if [ -z "$LAPTOP_PROFILE" ]; then
    local list_profile
    list_profile=$(laptop_profile_available)

    if [[ "$list_profile" = "$LAPTOP_PROFILE_DEFAULT" ]]; then
      LAPTOP_PROFILE="$LAPTOP_PROFILE_DEFAULT"
    else
      laptop_log info "Please select a configuration profile"
      select LAPTOP_PROFILE in $list_profile; do
        test -n "$LAPTOP_PROFILE" && break
        laptop_log error "Invalid Selection"
      done
    fi

    export LAPTOP_PROFILE
  fi
}
