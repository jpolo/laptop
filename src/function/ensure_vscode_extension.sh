#!/usr/bin/env bash

# Ensure VSCode extension
#
# Usage:
#   laptop_ensure_vscode_extension <extension_name>
#
laptop_ensure_vscode_extension() {
  local executable="${1:-$LAPTOP_VSCODE_EXECUTABLE}"
  # set local variable for app name
  local app_name
  app_name=$(laptop_vscode_app_name "$executable")

  local extension_name="$1"
  local list_extensions
  list_extensions=$(code --list-extensions)
  laptop_step_start "- Ensure $app_name '$extension_name'"

  if echo "$list_extensions" | grep -q "$extension_name"; then
    laptop_step_ok
  else
    laptop_step_exec $executable --install-extension "$extension_name" --force
  fi
}
