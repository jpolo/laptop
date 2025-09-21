#!/usr/bin/env bash

# Ensure VSCode is up to date
#
# Usage:
#   laptop_ensure_vscode_updated
#
# Example:
#   laptop_ensure_vscode_updated // -> uses default "code" executable
#   LAPTOP_VSCODE_EXECUTABLE=cursor laptop_ensure_vscode_updated // -> uses "cursor" executable
#
laptop_ensure_vscode_updated() {
  local executable="${LAPTOP_VSCODE_EXECUTABLE:-code}"
  # set local variable for app name
  local app_name
  app_name=$(laptop_vscode_app_name "$executable")

  laptop_step_start "- Upgrade $app_name"
  laptop_step_eval "$executable --update-extensions"
}
