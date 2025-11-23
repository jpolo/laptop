#!/usr/bin/env bash

laptop_command__config() {
  local config_type="$1"
  shift
  local action="view"

  while [[ $# -gt 0 ]]; do
    case $1 in
      --view)
        action="view"
        shift
        ;;
      --edit)
        action="edit"
        shift
        ;;
      *)
        break
        ;;
    esac
  done

  # Determine the configuration file based on the type
  local config_file=""
  case "$config_type" in
    "starship")
      config_file="${STARSHIP_CONFIG:-$XDG_CONFIG_HOME/starship/config.toml}"
      ;;
    "zsh")
      if [ -z "$LAPTOP_CONFIG_ZSH_FILE" ]; then
        laptop_die "LAPTOP_CONFIG_ZSH_FILE is not set"
      fi
      config_file="$LAPTOP_CONFIG_ZSH_FILE"
      ;;
    *)
      laptop_die "Unknown config type: $config_type"
      ;;
  esac

  # Perform the action
  case "$action" in
    "view")
      cat "$config_file"
      ;;
    "edit")
      ${EDITOR} "$config_file"
      ;;
    *)
      laptop_die "Unknown action: $action"
      ;;
  esac
}
