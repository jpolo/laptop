#!/usr/bin/env bash

laptop::command__configure_run() {
  local profile_file="$LAPTOP_PROFILE_DIR/$LAPTOP_PROFILE/profile.sh"
  if [ ! -f "$profile_file" ]; then
    laptop:die "Profile \"$LAPTOP_PROFILE\" does not exist"
  fi
  source "$profile_file"
}

laptop::command__configure() {
  laptop::logo

  # Select profile
  if [ -z "$LAPTOP_PROFILE" ]; then
    local list_profile=$(laptop::profile_available)

    if [[ "$list_profile" = "$LAPTOP_PROFILE_DEFAULT"  ]]; then
      LAPTOP_PROFILE="$LAPTOP_PROFILE_DEFAULT"
    else
      laptop::info "Please select a configuration profile"
      select LAPTOP_PROFILE in $list_profile; do
        test -n "$LAPTOP_PROFILE" && break;
        laptop::error "Invalid Selection";
      done
    fi
  fi

  laptop::info "Current profile is $(quote $LAPTOP_PROFILE)"

  # Ask confirmation
  laptop::info "This will install and configure all tools"
  if laptop::confirm "Continue? (Y/n)"; then
    laptop::command__configure_run
  else
    laptop::error "🛑 Upgrade aborted"
    exit 1
  fi
}

laptop::profile_available() {
  echo "$LAPTOP_PROFILE_DEFAULT"
  ls "$LAPTOP_PROFILE_DIR" | grep -v "$LAPTOP_PROFILE_DEFAULT" | sort
}
