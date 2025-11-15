#!/usr/bin/env bash

# Ensure VSCode setting
#
# Usage:
#   laptop_vscode_ensure_setting <json_path> <json_value> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_vscode_ensure_setting() {
  local executable="${LAPTOP_VSCODE_EXECUTABLE:-code}"
  # set local variable for app name
  local app_name
  app_name=$(laptop_vscode_app_name "$executable")

  local json_path="$1"
  local json_value="$2"
  # parse options
  local resource_status="present"
  if [ -z "$json_value" ]; then
    resource_status="absent"
  fi
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done
  local vscode_settings_file=""
  local jsonc_args

  if [ "$resource_status" = "absent" ]; then
    jsonc_args+=" --delete"
    json_value=""
  else
    jsonc_args+="-v $(quote "$json_value")"
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
    laptop_error "Empty json_path"
    return 1
  fi

  local current_value
  current_value="$(cat "$vscode_settings_file" | jsonc read "$json_path" 2>/dev/null)"

  local current_resource_status
  if [ "$resource_status" = "absent" ]; then
    current_resource_status=$([ ! -z "$current_value" ] && echo "present" || echo "absent")
  else
    current_resource_status=$([ "$current_value" = "$json_value" ] && echo "present" || echo "absent")
  fi
  local message
  message="$app_name setting $json_path=$json_value"

  # Try to install once jsonc-cli
  _LAPTOP_ENSURE_JSONC_CLI="${_LAPTOP_ENSURE_JSONC_CLI:-false}"
  if [ "$_LAPTOP_ENSURE_JSONC_CLI" = "false" ]; then
    _LAPTOP_ENSURE_JSONC_CLI="true"
    laptop_npm_ensure_package "jsonc-cli"
  fi

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_ok
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_eval "cat $(quote "$vscode_settings_file") | jsonc modify -n -m -p $(quote "$json_path") $jsonc_args -f $(quote "$vscode_settings_file")"
    else
      laptop_step_eval "cat $(quote "$vscode_settings_file") | jsonc modify -n -m -p $(quote "$json_path") $jsonc_args -f $(quote "$vscode_settings_file")"
    fi
  fi
}
