#!/usr/bin/env bash

laptop_require "laptop_brew_package_installed"

laptop_self_updated() {
  local current_branch
  local remote_sha
  local local_sha

  # Homebrew install (--HEAD): check if upstream has new commits
  # --fetch-HEAD is required for HEAD formulae; HOMEBREW_NO_AUTO_UPDATE=1 avoids slow tap updates
  if [[ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]] && laptop_brew_package_installed "$LAPTOP_INSTALL_BREW_PACKAGE"; then
    if HOMEBREW_NO_AUTO_UPDATE=1 brew outdated --quiet --fetch-HEAD "$LAPTOP_INSTALL_BREW_PACKAGE" 2>/dev/null | grep -q .; then
      return 1 # Outdated
    fi
    return 0 # Up-to-date
  fi

  # Git install (e.g. zinit or manual clone): check if remote is ahead
  # Use ls-remote instead of fetch so we don't download objects on every check
  if [[ -d "$LAPTOP_HOME/.git" ]]; then
    current_branch=$(git -C "$LAPTOP_HOME" rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -z "$current_branch" ]] && return 0

    remote_sha=$(git -C "$LAPTOP_HOME" ls-remote origin "$current_branch" 2>/dev/null | cut -f1)
    [[ -z "$remote_sha" ]] && return 0 # Can't tell, assume up-to-date

    local_sha=$(git -C "$LAPTOP_HOME" rev-parse HEAD 2>/dev/null)
    # Behind = local is ancestor of remote and not equal
    if [[ -n "$local_sha" ]] && git -C "$LAPTOP_HOME" merge-base --is-ancestor HEAD "$remote_sha" 2>/dev/null && [[ "$local_sha" != "$remote_sha" ]]; then
      return 1 # Outdated
    fi
  fi
  return 0 # Up-to-date
}
