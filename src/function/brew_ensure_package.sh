#!/usr/bin/env bash

# Install brew `package` if not present
#
# Usage:
#   laptop_brew_ensure_package <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_brew_ensure_package() {
  local package="$1"
  # parse options
  local package_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) package_status="$2"; shift 2;;
      *) shift;;
    esac
  done

  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  export HOMEBREW_NO_ENV_HINTS=1
  local brew_args=("--quiet")

  local current_package_status
  current_package_status=$(brew list "$package" &>/dev/null && echo "present" || echo "absent")
  local message="brew package '$package'"

  # shellcheck disable=SC2076
  if [ ! -z "$BREW_CASK" ];then
    brew_args+=("--cask")
  fi

  if [ "$current_package_status" = "$package_status" ]; then
    laptop_step_start_status "unchanged" "$message"
    laptop_step_ok
  else
    laptop_step_start_status "$package_status" "$message"
    if [ "$package_status" = "present" ]; then
      laptop_step_eval "brew install ${brew_args[*]} $(quote "$package")"
    else
      laptop_step_eval "brew uninstall ${brew_args[*]} $(quote "$package") --force"
    fi
  fi
}

laptop_brew_ensure_cask_package() {
  BREW_CASK=1 laptop_brew_ensure_package "$1"
}
