#!/usr/bin/env bash

laptop_require "laptop_mcp_ensure"
laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_log"

# Ensure a remote MCP server in Cursor (agent + IDE)
#
# Usage:
#   laptop_mcp_ensure__cursor <name> <url>
#
laptop_mcp_ensure__cursor() {
  local name="$1"
  local url="$2"
  local failed=0

  # Agent store: ~/.cursor/mcp.json under mcpServers
  local agent_file="${LAPTOP_CURSOR_MCP_FILE:-$HOME/.cursor/mcp.json}"
  local agent_status="absent"
  if [ -f "$agent_file" ] && jq -e --arg name "$name" '.mcpServers[$name] != null' "$agent_file" &>/dev/null; then
    agent_status="present"
  fi

  laptop_step_start_status "present" "$agent_status" "Cursor agent MCP '$name'"
  if [ "$agent_status" = "present" ]; then
    laptop_step_status "ok"
  else
    mkdir -p "$(dirname "$agent_file")"
    if [ ! -f "$agent_file" ]; then
      echo '{"mcpServers":{}}' >"$agent_file"
    fi

    local tmp_file
    tmp_file="$(mktemp)"
    if jq --arg name "$name" --arg url "$url" \
      '.mcpServers[$name] = {"url": $url}' \
      "$agent_file" >"$tmp_file" && mv "$tmp_file" "$agent_file"; then
      laptop_step_status "ok"
    else
      rm -f "$tmp_file"
      laptop_step_status "fail"
      laptop_log error "Failed to write Cursor agent MCP '$name'"
      failed=1
    fi
  fi

  # IDE store: Cursor/User/mcp.json via cursor --add-mcp
  local ide_file
  ide_file="$(laptop_mcp_ide_config_path "Cursor")"
  local ide_status="absent"
  if [ -f "$ide_file" ] && jq -e --arg name "$name" '.mcpServers[$name] != null' "$ide_file" &>/dev/null; then
    ide_status="present"
  fi

  laptop_step_start_status "present" "$ide_status" "Cursor IDE MCP '$name'"
  if [ "$ide_status" = "present" ]; then
    laptop_step_status "ok"
  else
    local payload
    payload="$(jq -nc --arg name "$name" --arg url "$url" '{name: $name, url: $url}')"
    local output
    output=$(cursor --add-mcp "$payload" 2>&1)
    local exit_code=$?
    if [ "$exit_code" = "0" ]; then
      laptop_step_status "ok"
    else
      laptop_step_status "fail"
      laptop_log error "Command failed \
      \\n|  > cursor --add-mcp $(quote "$payload") \
      \\n|  $output"
      failed=1
    fi
  fi

  return "$failed"
}
