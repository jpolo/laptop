#!/usr/bin/env bash

# Ensure VSCode setting
#
# Usage:
#   laptop_ensure_vscode_setting <json_path> <json_value>
#
laptop_ensure_vscode_setting() {
  local executable="${1:-$LAPTOP_VSCODE_EXECUTABLE}"
  # set local variable for app name
  local app_name
  app_name=$(laptop_vscode_app_name "$executable")

  local json_path="$1"
  local json_value="$2"
  local vscode_settings_file=""
  local jsonc_args
  jsonc_args="-v $(quote "$json_value")"
  if [ "$json_value" = "" ]; then
    jsonc_args="--delete"
  fi

  # Vérifier si le système d'exploitation est macOS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    vscode_settings_file="$HOME/Library/Application Support/Code/User/settings.json"
  else
    vscode_settings_file="$HOME/.config/Code/User/settings.json"
  fi

  # Vérifier si la requête est vide
  if [ -z "$json_path" ]; then
    laptop_error "La requête est vide."
    return 1
  fi

  laptop_step_start "- Ensure $app_name Setting $json_path=$json_value"
  laptop_step_eval "\
  cat $(quote "$vscode_settings_file") | \
  jsonc modify -n -m -p $(quote "$json_path") $jsonc_args -f $(quote "$vscode_settings_file") \
  "
}
