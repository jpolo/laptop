#!/usr/bin/env bash

laptop_command__config() {
  local action="$1"
  shift
  local config_type="${1:-"self"}"
  shift

  # Determine the configuration file based on the type
  local config_file=""
  case "$config_type" in
  "self")
    config_file="$LAPTOP_USER_CONFIG_FILE"
    ;;
  "git")
    config_file="$(laptop_xdg_dir "config")/git/config"
    ;;
  "starship")
    config_file="${STARSHIP_CONFIG:-$(laptop_xdg_dir "config")/starship/config.toml}"
    shift
    ;;
  "zsh")
    if [ -z "$LAPTOP_CONFIG_ZSH_FILE" ]; then
      laptop_die "LAPTOP_CONFIG_ZSH_FILE is not set"
    fi
    config_file="$LAPTOP_CONFIG_ZSH_FILE"
    shift
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
