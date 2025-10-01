#!/usr/bin/env bash

# Ensure VSCode extension
#
# Usage:
#   laptop_vscode_ensure_extension <extension_name> [--status present|absent]
# Options:
#   --status present|absent
#
laptop_vscode_ensure_extension() {
  local executable="${LAPTOP_VSCODE_EXECUTABLE:-code}"
  # set local variable for app name
  local app_name
  app_name=$(laptop_vscode_app_name "$executable")
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  local extension_name="$1"
  local list_extensions
  list_extensions=$(code --list-extensions)
  laptop_step_start_status "$resource_status" "$app_name extension '$extension_name'"

  if [ "$resource_status" = "present" ]; then
    if echo "$list_extensions" | grep -q "$extension_name"; then
      laptop_step_ok
    else
      laptop_step_exec "$executable" --install-extension "$extension_name" --force
    fi
  else
    laptop_step_exec "$executable" --uninstall-extension "$extension_name"  --force
  fi
}
