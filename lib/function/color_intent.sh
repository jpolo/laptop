#!/usr/bin/env bash

laptop_require "laptop_ansi"

# Detect the color intent
#
# Usage:
#   laptop_color_intent <intent>
#
# Intent:
#   - success: success color
#   - error: error color
#   - warn: warning color
#   - info: info color
laptop_color_intent() {
  local intent="$1"
  case "$intent" in
    "success")
      laptop_ansi green
    ;;
    "error")
      laptop_ansi red
    ;;
    "warn")
      laptop_ansi yellow
    ;;
    "info")
      laptop_ansi blue
  esac
}
