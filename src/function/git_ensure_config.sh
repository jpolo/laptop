#!/usr/bin/env bash

laptop_git_ensure_config() {
  local name="$1"
  local value="$2"

  laptop_step_start "- Ensure git config '$name'='${value:-"<custom>"}'"
  if [ -z "$(git config --global "$name")" ]; then
    if [ -z "${value}" ]; then
      echo "Git: Please enter value for '$name'"
      read -r value
    fi

    laptop_step_exec git config --global "$name" "$value"
  else
    laptop_step_ok
  fi
}
