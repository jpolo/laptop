#!/usr/bin/env bash

laptop_command__configure_run() {
  # Bootstrap
  laptop_handler_call "configure_bootstrap"
  laptop_handler_call "configure_shell"

  # Complete installation if LAPTOP_BOOTSTRAP omitted or false
  if [ "${LAPTOP_BOOTSTRAP:-false}" = false ]; then
    laptop_configure_steps
  fi
}

laptop_command__configure() {
  laptop_handler_call "logo"
  laptop_self_check_version

  if [ -z "$LAPTOP_GIT_REMOTE" ]; then
    laptop_warn "LAPTOP_GIT_REMOTE is not set and is required for self updating"
    laptop_info "LAPTOP_GIT_REMOTE can have the following value :"
    laptop_info "  - A repository identifier (ex: jpolo/laptop)"
    laptop_info "  - A full repository url (ex: https://github.com/jpolo/laptop.git)"
    laptop_info "  - (empty value) to skip"
    printf "LAPTOP_GIT_REMOTE? : "
    read -e -r LAPTOP_GIT_REMOTE
  fi

  laptop_info "  Profile: ${BRACKET}${LAPTOP_PROFILE}${NORMAL}"
  laptop_info "  Dev Container: ${BRACKET}${LAPTOP_DEVCONTAINER}${NORMAL}"

  # Ask confirmation
  if [ "${LAPTOP_BOOTSTRAP:-false}" = true ]; then
    laptop_info "  Install Mode: ${BRACKET}bootstrap${NORMAL} ${DIM}(only laptop and zshrc)${NORMAL}"
  else
    laptop_info "  InstallMode: ${BRACKET}complete${NORMAL} ${DIM}(complete installation)${NORMAL}"
  fi
  if laptop_confirm "Continue? (Y/n)"; then
    laptop_command__configure_run
  else
    laptop_die "🛑 Upgrade aborted"
  fi
}
