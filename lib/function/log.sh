#!/usr/bin/env bash

laptop_require "laptop_color_intent"

##
# Log a message
#
# Usage:
#   laptop_log <level> <message>
#
# Level:
#   - info: Info
#   - warning: Warning
#   - error: Error
#
# Message:
#   The message to log
#
# Example:
#   laptop_log info "This is an info message"
#   laptop_log warning "This is a warning message"
#   laptop_log error "This is an error message"
#   laptop_log unknown "This is an unknown message"
laptop_log() {
  local level="$1"
  local message="$2"
  local color="$COLOR_NORMAL"
  local level_name

  case "$level" in
    "info")
      color="$(laptop_color_intent info)"
      level_name="Info"
      ;;
    "warn")
      color="$(laptop_color_intent warn)"
      level_name="Warning"
      ;;
    "error")
      color="$(laptop_color_intent error)"
      level_name="Error"
      ;;
    *)
      color="$NORMAL"
      level_name="Unknown"
      ;;
  esac
  echo -e "${color}${level_name}: ${NORMAL}${message}"
}
