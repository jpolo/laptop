#!/usr/bin/env bash

laptop_require "laptop_mcp_ensure"
laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_log"

# Ensure a remote MCP server in VS Code
#
# Usage:
#   laptop_mcp_ensure__code <name> <url>
#
laptop_mcp_ensure__code() {
  local name="$1"
  local url="$2"
  local failed=0

  local ide_file
  ide_file="$(laptop_mcp_ide_config_path "Code")"
  local ide_status="absent"
  if [ -f "$ide_file" ] && jq -e --arg name "$name" '.servers[$name] != null' "$ide_file" &>/dev/null; then
    ide_status="present"
  fi

  laptop_step_start_status "present" "$ide_status" "VS Code MCP '$name'"
  if [ "$ide_status" = "present" ]; then
    laptop_step_status "ok"
  else
    local payload
    payload="$(jq -nc --arg name "$name" --arg url "$url" '{name: $name, type: "http", url: $url}')"
    local output
    output=$(code --add-mcp "$payload" 2>&1)
    local exit_code=$?
    if [ "$exit_code" = "0" ]; then
      laptop_step_status "ok"
    else
      laptop_step_status "fail"
      laptop_log error "Command failed \
      \\n|  > code --add-mcp $(quote "$payload") \
      \\n|  $output"
      failed=1
    fi
  fi

  return "$failed"
}
