#!/usr/bin/env bash

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
      laptop_info "Please select a configuration profile"
      select LAPTOP_PROFILE in $list_profile; do
        test -n "$LAPTOP_PROFILE" && break
        laptop_error "Invalid Selection"
      done
    fi

    export LAPTOP_PROFILE
  fi
}
