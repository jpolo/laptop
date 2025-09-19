#!/usr/bin/env bash

# Ensure VSCode is up to date
#
# Usage:
#   laptop_ensure_vscode_updated <executable>
#
laptop_ensure_vscode_updated() {
  local executable="${1:-$LAPTOP_VSCODE_EXECUTABLE}"
  # set local variable for app name
  local app_name="VSCode"
  if [ "$executable" = "code-insiders" ]; then
    app_name="VSCode Insiders"
  elif [ "$executable" = "cursor" ]; then
    app_name="Cursor"
  fi

  laptop_step_start "- Upgrade $app_name"
  laptop_step_eval "$executable --update-extensions"
}
