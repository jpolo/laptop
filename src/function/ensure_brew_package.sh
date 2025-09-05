#!/usr/bin/env bash

# Install brew `package` if not present
#
# Usage:
#   laptop::ensure_brew_package <package>
#
laptop::ensure_brew_package() {
  local package="$1"

  laptop::step_start "- Ensure brew package '$package'"

  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  export HOMEBREW_NO_ENV_HINTS=1
  local brew_args=("--quiet")

  # shellcheck disable=SC2076
  if [ ! -z "$BREW_CASK" ];then
    brew_args+=("--cask")
  fi

  if brew list "$package" &>/dev/null; then
    laptop::step_ok
  else
    laptop::step_eval "brew install ${brew_args[*]} $(quote "$package")"
  fi
}

laptop::ensure_brew_cask_package() {
  BREW_CASK=1 laptop::ensure_brew_package "$1"
}
