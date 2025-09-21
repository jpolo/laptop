#!/usr/bin/env bash

# Get the name of the VSCode app
#
# Usage:
#   laptop_vscode_app_name <executable>
#
laptop_vscode_app_name() {
  local executable="$1"
  local app_name="VSCode"
  if [ "$executable" = "code-insiders" ]; then
    app_name="VSCode Insiders"
  elif [ "$executable" = "cursor" ]; then
    app_name="Cursor"
  fi
  echo "$app_name"
}
