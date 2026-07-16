#!/usr/bin/env bash

laptop_require "laptop_log"
laptop_require "laptop_ansi"
laptop_require "laptop_color_intent"
laptop_require "laptop_handler_call"
laptop_require "laptop_self_version"
laptop_require "laptop_self_latest_version"
laptop_require "laptop_self_updated"
laptop_require "laptop_brew_package_installed"
laptop_require "laptop_profile_available"
laptop_require "laptop_disk_available_space"

# Ordered list of checks run by `laptop doctor`.
# To add a check: implement laptop_doctor_check__<name> and append <name> here.
__LAPTOP_DOCTOR_CHECKS=(version install profile disk)

# Print a single doctor result line with optional color intent
#
# Usage:
#   laptop_doctor_line <label> <value> [intent]
#
# Intent: success | warn | error | info (maps to laptop_color_intent)
#
laptop_doctor_line() {
  local label="$1"
  local value="$2"
  local intent="${3:-}"
  local color=""
  local reset=""

  if [[ -n "$intent" ]]; then
    color=$(laptop_color_intent "$intent")
    reset=$(laptop_ansi reset)
  fi

  printf "  %-12s %s%s%s\n" "$label" "$color" "$value" "$reset"
}

laptop_doctor_check__version() {
  local current latest status intent

  current=$(laptop_self_version)
  latest=$(laptop_self_latest_version)

  if laptop_self_updated; then
    status="up-to-date"
    intent="success"
  else
    status="outdated"
    intent="warn"
  fi

  laptop_doctor_line "Version" "$current"
  laptop_doctor_line "Latest" "$latest"
  laptop_doctor_line "Status" "$status" "$intent"
}

laptop_doctor_check__install() {
  local method

  if [[ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]] && laptop_brew_package_installed "$LAPTOP_INSTALL_BREW_PACKAGE"; then
    method="brew ($LAPTOP_INSTALL_BREW_PACKAGE)"
  elif [[ -d "$LAPTOP_HOME/.git" ]]; then
    method="git"
  else
    method="manual"
  fi

  laptop_doctor_line "Install" "$method"
  laptop_doctor_line "Home" "$LAPTOP_HOME"
}

laptop_doctor_check__profile() {
  local profile="${LAPTOP_PROFILE:-}"
  local intent="success"

  if [[ -z "$profile" ]]; then
    laptop_doctor_line "Profile" "(none set)" "warn"
    return
  fi

  if ! laptop_profile_available | grep -qx "$profile"; then
    intent="warn"
  fi

  laptop_doctor_line "Profile" "$profile" "$intent"
}

laptop_doctor_check__disk() {
  local b d s
  b=$(laptop_disk_available_space)
  d=''
  s=0
  local S=("KiB" "MiB" "GiB" "TiB" "EiB" "PiB" "YiB" "ZiB")
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    ((s++))
  done
  laptop_doctor_line "Disk" "$b$d ${S[$s]} available"
}

laptop_command__doctor() {
  laptop_handler_call "logo"

  echo "Laptop Doctor"
  echo ""

  local check
  for check in "${__LAPTOP_DOCTOR_CHECKS[@]}"; do
    "laptop_doctor_check__${check}"
  done

  echo ""
}
