#!/usr/bin/env bash

laptop_command__config() {
  local subcommand="$1"
  shift
  local args=("$@")
  laptop_handler_call "config_$subcommand" "${args[@]}"
}

laptop_handler__config_view() {
  if [ -z "$LAPTOP_CONFIG_FILE" ]; then
    laptop_die "LAPTOP_CONFIG_FILE is not set"
  fi
  cat "$LAPTOP_CONFIG_FILE"
}

laptop_handler__config_edit() {
  if [ -z "$LAPTOP_CONFIG_FILE" ]; then
    laptop_die "LAPTOP_CONFIG_FILE is not set"
  fi
  ${EDITOR} "$LAPTOP_CONFIG_FILE"
}
