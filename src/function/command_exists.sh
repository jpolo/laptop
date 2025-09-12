#!/usr/bin/env bash

#
# Usage:
#   laptop_command_exists <command>
#
laptop_command_exists() {
  local tool
  tool="$1"
  case "$tool" in
  zinit)
    if env "$SHELL" --login -i -c "command -v $tool" &>/dev/null; then
      return 0
    fi
    ;;
  *)
    if [ -x "$(command -v "$1")" ]; then
      return 0
    fi
    ;;
  esac

  return 1
}
