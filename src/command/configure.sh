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
  laptop::info "This will install and configure all tools"
  laptop::info "  LAPTOP_PROFILE=$LAPTOP_PROFILE"
  if laptop::confirm "Continue? (Y/n)"; then
    __program_configure_run
  else
    laptop::error "🛑 Upgrade aborted"
    exit 1
  fi
}



