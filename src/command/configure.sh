#!/usr/bin/env bash

laptop_command__configure_run() {
  # Load profile (with overrides)
  laptop_profile_load

  # Bootstrap
  laptop_bootstrap
  laptop_configure_default_shell

  # Installation
  laptop_configure_steps
}

laptop_command__configure() {
  laptop_logo
  laptop_self_check_version

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
  fi

  if [ -z "$LAPTOP_GIT_REMOTE" ]; then
    laptop_warn "LAPTOP_GIT_REMOTE is not set and is required for self updating"
    laptop_info "LAPTOP_GIT_REMOTE can have the following value :"
    laptop_info "  - A repository identifier (ex: jpolo/laptop)"
    laptop_info "  - A full repository url (ex: https://github.com/jpolo/laptop.git)"
    laptop_info "  - (empty value) to skip"
    printf "LAPTOP_GIT_REMOTE? : "
    read -e -r LAPTOP_GIT_REMOTE
  fi

  laptop_info "Current profile is $(quote "$LAPTOP_PROFILE")"

  # Ask confirmation
  laptop_info "This will install and configure all tools"
  if laptop_confirm "Continue? (Y/n)"; then
    laptop_command__configure_run
  else
    laptop_error "🛑 Upgrade aborted"
    exit 1
  fi
}
