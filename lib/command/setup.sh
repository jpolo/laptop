#!/usr/bin/env bash

laptop_require "laptop_handler_call"
laptop_require "laptop_log"
laptop_require "laptop_self_check_version"
laptop_require "laptop_confirm"
laptop_require "laptop_die"
laptop_require "laptop_setup_steps"

laptop_command__setup_run() {
  # Bootstrap
  laptop_handler_call "setup_bootstrap"
  laptop_handler_call "setup_shell"

  # Complete installation if LAPTOP_BOOTSTRAP omitted or false
  if [ "${LAPTOP_BOOTSTRAP:-false}" = false ]; then
    laptop_setup_steps
  fi
}

laptop_command__setup() {
  laptop_handler_call "logo"
  laptop_self_check_version

  if [ -z "$LAPTOP_GIT_REMOTE" ]; then
    laptop_log warn "LAPTOP_GIT_REMOTE is not set and is required for self updating"
    laptop_log info "LAPTOP_GIT_REMOTE can have the following value :"
    laptop_log info "  - A repository identifier (ex: jpolo/laptop)"
    laptop_log info "  - A full repository url (ex: https://github.com/jpolo/laptop.git)"
    laptop_log info "  - (empty value) to skip"
    printf "LAPTOP_GIT_REMOTE? : "
    read -e -r LAPTOP_GIT_REMOTE
  fi

  local color_config
  color_config="$(laptop_ansi bold)$(laptop_ansi blue)"

  laptop_log info "  Profile: ${color_config}${LAPTOP_PROFILE}${NORMAL}"
  laptop_log info "  Dev Container: ${color_config}${LAPTOP_DEVCONTAINER}${NORMAL}"

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

## Legacy command handler
laptop_command__configure() {
  laptop_handler_call "logo"
  laptop_die "🛑 'laptop configure' was removed. Use 'laptop setup' instead."
}
