#!/usr/bin/env bash

laptop_self_updated() {
  local current_branch
  local behind_count

  if [[ -d "$LAPTOP_HOME/.git" ]]; then
    # laptop is managed with git
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
