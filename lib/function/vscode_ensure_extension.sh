#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"
laptop_require "laptop_vscode_app_name"

# Ensure VSCode extension
#
# Usage:
#   laptop_vscode_ensure_extension <extension_name> [--status present|absent]
# Options:
#   --status present|absent
#
laptop_vscode_ensure_extension() {
  local executable="${LAPTOP_VSCODE_EXECUTABLE:-code}"
  local extension_name="$1"
  # set local variable for app name
  local app_name
  app_name=$(laptop_vscode_app_name "$executable")
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
  local list_extensions
  list_extensions=$(code --list-extensions)

  local resource_current_status
  resource_current_status=$(echo "$list_extensions" | grep -iq "$extension_name" && echo "present" || echo "absent")
  laptop_step_start_status "$resource_status" "$resource_current_status" "$app_name extension '$extension_name'"

  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec "$executable" --install-extension "$extension_name" --force
    else
      laptop_step_exec "$executable" --uninstall-extension "$extension_name" --force
    fi
  fi
}
