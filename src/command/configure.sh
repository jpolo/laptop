#!/usr/bin/env bash

__program_configure_run() {
  local profile_file="$LAPTOP_PROFILE_DIR/$LAPTOP_PROFILE/profile.sh"
  if [ ! -f "$profile_file" ]; then
    laptop:die "Profile \"$LAPTOP_PROFILE\" does not exist"
  fi
  source "$profile_file"
}

__program_configure() {
  laptop::logo

  # Select profile
  if [ -z "$LAPTOP_PROFILE" ]; then
    local list_profile=$(ls $LAPTOP_PROFILE_DIR)

    if [[ "$list_profile" = "default"  ]]; then
      LAPTOP_PROFILE="default"
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
    __program_configure_run
  else
    laptop::error "🛑 Upgrade aborted"
    exit 1
  fi
}

laptop::profile_available() {
  ls $LAPTOP_PROFILE_DIR
}


