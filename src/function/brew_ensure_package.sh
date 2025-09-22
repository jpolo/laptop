#!/usr/bin/env bash

# Install brew `package` if not present
#
# Usage:
#   laptop_brew_ensure_package <package>
#
laptop_brew_ensure_package() {
  local package="$1"

  laptop_step_start "- Ensure brew package '$package'"

  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  export HOMEBREW_NO_ENV_HINTS=1
  local brew_args=("--quiet")

  # shellcheck disable=SC2076
  if [ ! -z "$BREW_CASK" ];then
    brew_args+=("--cask")
  fi

  if brew list "$package" &>/dev/null; then
    laptop_step_ok
  else
    laptop_step_eval "brew install ${brew_args[*]} $(quote "$package")"
  fi
}

laptop_brew_ensure_cask_package() {
  BREW_CASK=1 laptop_brew_ensure_package "$1"
}
