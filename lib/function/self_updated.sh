#!/usr/bin/env bash

laptop_self_updated() {
  local current_branch
  local behind_count

  # Homebrew install: check if a newer formula version is available
  if [[ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]] && brew list "$LAPTOP_INSTALL_BREW_PACKAGE" &>/dev/null; then
    if brew outdated --quiet "$LAPTOP_INSTALL_BREW_PACKAGE" 2>/dev/null | grep -q .; then
      return 1 # Outdated
    fi
    return 0 # Up-to-date
  fi

  # Git install (e.g. zinit or manual clone): check if remote is ahead
  if [[ -d "$LAPTOP_HOME/.git" ]]; then
    current_branch=$(git -C "$LAPTOP_HOME" rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Fetch updates from the remote
    git -C "$LAPTOP_HOME" --git-dir="$LAPTOP_HOME/.git" fetch origin >/dev/null 2>&1 || true

    # Check if the working directory is outdated
    behind_count=$(git -C "$LAPTOP_HOME" rev-list --left-right --count HEAD...origin/"$current_branch" 2>/dev/null | awk '{print $2}')

    # If behind_count is greater than 0, the repo is outdated
    if [[ "$behind_count" -gt 0 ]]; then
      return 1 # Outdated
    fi
  fi
  return 0 # Up-to-date
}
