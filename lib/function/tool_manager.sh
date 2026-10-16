#!/usr/bin/env bash

# Return a formatted tool manager step message
#
# Usage:
#   laptop_tool_manager
#
laptop_tool_manager() {
  # IF define LAPTOP_TOOL_MANAGER, use it; otherwise, return a default message
  if [ -n "$LAPTOP_TOOL_MANAGER" ]; then
    echo "$LAPTOP_TOOL_MANAGER"
  # otherwise check if command exist mise then asdf
  elif command -v mise >/dev/null 2>&1; then
    echo "mise"
  elif command -v asdf >/dev/null 2>&1; then
    echo "asdf"
  else
    laptop_log error "No tool manager found"
    return 1
  fi
}
