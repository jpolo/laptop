#!/usr/bin/env bash

laptop::ensure_brew_autodate() {
  local brew_autodate_present=$(env -i zsh --login -c 'brew autoupdate status &>/dev/null;echo $?');

  laptop::step_start "- Ensure package manager 'brew autoupdate'"
  if [ "$brew_autodate_present" != "0" ]; then
    brew tap homebrew/autoupdate
  fi

  if ! brew autoupdate status | grep --quiet running; then
    brew autoupdate start &>/dev/null && \
      laptop::step_ok || \
      laptop::step_fail
  else
    laptop::step_ok
  fi
}
