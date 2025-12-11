#!/usr/bin/env bash

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
      color="$COLOR_INFO"
      level_name="Info"
      ;;
    "warning")
      color="$COLOR_WARNING"
      level_name="Warning"
      ;;
    "error")
      color="$COLOR_ERROR"
      level_name="Error"
      ;;
    *)
      color="$COLOR_NORMAL"
      level_name="Unknown"
      ;;
  esac
  echo -e "${color}${level_name}: ${message}${NORMAL}"
}
