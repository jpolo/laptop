#!/usr/bin/env bash

laptop_require "laptop_log"
laptop_require "laptop_confirm"
laptop_require "laptop_die"
laptop_require "laptop_handler_call"
laptop_require "laptop_self_ensure_updated"

laptop_command__self-upgrade() {
  laptop_handler_call "logo"
  echo "Laptop is going to be upgraded to the latest version"
  echo ""
  if laptop_confirm "Continue? (y/N)"; then
    laptop_command__self-upgrade_run

    laptop_log info "🎉 Self upgrade finished"
  else
    laptop_die "🛑 Upgrade aborted"
  fi
}

# Upgrade only the laptop CLI (when installed via Homebrew).
# When installed via git/zinit, use 'laptop upgrade' to update from the remote.
#
laptop_command__self-upgrade_run() {
  if [ -z "$LAPTOP_INSTALL_BREW_PACKAGE" ] || ! brew list "$LAPTOP_INSTALL_BREW_PACKAGE" &>/dev/null; then
    laptop_log warn "laptop is not installed via Homebrew ($LAPTOP_INSTALL_BREW_PACKAGE). Please run in your terminal :\n\n\
    brew install $LAPTOP_INSTALL_BREW_PACKAGE\n\n"
    return 0
  fi

  laptop_self_ensure_updated
}
