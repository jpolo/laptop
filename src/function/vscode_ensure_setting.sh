#!/usr/bin/env bash

# Ensure VSCode setting
#
# Usage:
#   laptop_vscode_ensure_setting <json_path> <json_value>
#
laptop_vscode_ensure_setting() {
  local executable="${LAPTOP_VSCODE_EXECUTABLE:-code}"
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

  local app_dir="Code"
  if [ "$executable" = "code-insiders" ]; then
    app_dir="Code - Insiders"
  elif [ "$executable" = "cursor" ]; then
    app_dir="Cursor"
  fi
  local vscode_relative_path="$app_dir/User/settings.json"

  # Vérifier si le système d'exploitation est macOS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    vscode_settings_file="$HOME/Library/Application Support/$vscode_relative_path"
  else
    vscode_settings_file="$(laptop_xdg_dir config)/$vscode_relative_path"
  fi

  # Vérifier si la requête est vide
  if [ -z "$json_path" ]; then
    laptop_error "La requête est vide."
    return 1
  fi

  laptop_step_start_status "present" "$app_name setting $json_path=$json_value"
  laptop_step_eval "\
  cat $(quote "$vscode_settings_file") | \
  jsonc modify -n -m -p $(quote "$json_path") $jsonc_args -f $(quote "$vscode_settings_file") \
  "
}
