#!/usr/bin/env bash

laptop_brew_ensure_autodate() {
  local brew_auto_update_present
  brew_auto_update_present=$(env -i zsh --login -c 'brew autoupdate status &>/dev/null;echo $?')

  laptop_step_start "- Ensure package manager 'brew autoupdate'"
  if [ "$brew_auto_update_present" != "0" ]; then
    brew tap homebrew/autoupdate
  fi

  if ! brew autoupdate status | grep --quiet running; then
    laptop_step_exec brew autoupdate start
  else
    laptop_step_ok
  fi
}
