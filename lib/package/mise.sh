#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"
laptop_require "laptop_step_start"
laptop_require "laptop_step_status"
laptop_require "laptop_log"
laptop_require "laptop_xdg_dir"

laptop_package_ensure__mise() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_package_ensure_default "mise"
    return
  fi

  local package="$1"
  # parse options
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local current_resource_status
  current_resource_status=$(command -v mise >/dev/null 2>&1 && echo "present" || echo "absent")

  laptop_step_resource_start_status "$package" --status "$resource_status" --current-status "$current_resource_status"

  local mise_path
  mise_path="$(laptop_xdg_dir bin)/mise"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_eval "curl -fsSL https://mise.run | MISE_INSTALL_PATH=\"$mise_path\" sh"
    else
      laptop_step_exec "echo 'Not supported'; exit 1"
    fi
  fi
}
