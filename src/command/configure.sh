#!/usr/bin/env bash

laptop::command__configure_run() {
  laptop::profile_load
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

  if [ -z "$LAPTOP_GIT_REMOTE" ]; then
    laptop::warn "LAPTOP_GIT_REMOTE is not set and is required for self updating"
    laptop::info "LAPTOP_GIT_REMOTE can have the following value :"
    laptop::info "  - A repository identifier (ex: jpolo/laptop)"
    laptop::info "  - A full repository url (ex: https://github.com/jpolo/laptop.git)"
    laptop::info "  - (empty value) to skip"
    printf "LAPTOP_GIT_REMOTE? : "
    read -e LAPTOP_GIT_REMOTE
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
