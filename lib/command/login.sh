#!/usr/bin/env bash

laptop_require "laptop_handler_call"
laptop_require "laptop_self_ensure_profile_updated"
laptop_require "laptop_shell_exec_dir_d"
laptop_require "laptop_profile_dir"
laptop_require "laptop_confirm"
laptop_require "laptop_die"
laptop_require "laptop_log"

# Run the profile's login.d steps
laptop_command__login() {
  laptop_handler_call "logo"

  if laptop_confirm "Continue? (y/N)"; then
    laptop_log info "Running login steps for profile ${LAPTOP_PROFILE}"
    LAPTOP_SOURCE_ALL=true laptop_shell_exec_dir_d "$(laptop_profile_dir)/login.d"
  else
    laptop_die "🛑 Login aborted"
  fi
}
