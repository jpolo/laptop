#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"
laptop_require "laptop_vscode_app_name"

# Ensure VSCode is up to date
#
# Usage:
#   laptop_vscode_ensure_updated
#
# Example:
#   laptop_vscode_ensure_updated // -> uses default "code" executable
#   LAPTOP_VSCODE_EXECUTABLE=cursor laptop_vscode_ensure_updated // -> uses "cursor" executable
#
laptop_vscode_ensure_updated() {
  local executable="${LAPTOP_VSCODE_EXECUTABLE:-code}"
  # set local variable for app name
  local app_name
  app_name=$(laptop_vscode_app_name "$executable")

  laptop_step_upgrade_start "$app_name updated"
  laptop_step_eval "$executable --update-extensions"
}
