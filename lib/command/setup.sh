#!/usr/bin/env bash

laptop_require "laptop_handler_call"
laptop_require "laptop_log"
laptop_require "laptop_self_check_version"
laptop_require "laptop_confirm"
laptop_require "laptop_die"
laptop_require "laptop_setup_steps"
laptop_require "laptop_self_ensure_profile_updated"
laptop_require "laptop_self_state_ensure"
laptop_require "laptop_date_now"

laptop_command__setup_run() {
  # Bootstrap
  laptop_handler_call "setup_bootstrap"
  laptop_handler_call "setup_shell"

  # Complete installation if LAPTOP_BOOTSTRAP omitted or false
  if [ "${LAPTOP_BOOTSTRAP:-false}" = false ]; then
    laptop_self_ensure_profile_updated
    laptop_setup_steps
  fi

  laptop_self_state_ensure "setup_last_completed_at" "$(laptop_date_now)"
}

laptop_command__setup() {
  laptop_handler_call "logo"
  laptop_self_check_version

  local color_config
  color_config="$(laptop_ansi bold)$(laptop_ansi blue)"

  laptop_log info "  Profile: ${color_config}${LAPTOP_PROFILE}${NORMAL}"
  laptop_log info "  Dev Container: ${color_config}${LAPTOP_DEVCONTAINER}${NORMAL}"
  if [ -n "$LAPTOP_GIT_REMOTE" ]; then
    laptop_log info "  Git Remote: ${color_config}${LAPTOP_GIT_REMOTE}${NORMAL}"
  fi

  # Ask confirmation
  if [ "${LAPTOP_BOOTSTRAP:-false}" = true ]; then
    laptop_log info "  Install Mode: ${color_config}bootstrap${NORMAL} ${DIM}(only laptop and zshrc)${NORMAL}"
  else
    laptop_log info "  Install Mode: ${color_config}complete${NORMAL} ${DIM}(complete installation)${NORMAL}"
  fi
  if laptop_confirm "Continue? (y/N)"; then
    laptop_command__setup_run
  else
    laptop_die "🛑 Upgrade aborted"
  fi
}
