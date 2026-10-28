#!/usr/bin/env bash

laptop_require "laptop_filter_command_exists"
laptop_require "laptop_function_exists"
laptop_require "laptop_log"
laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_xdg_dir"

# Implemented MCP providers that can be auto-detected via CLI presence
__LAPTOP_MCP_PROVIDER_CANDIDATES=("cursor" "code")

# Resolve MCP config path for a VS Code–compatible IDE
#
# Usage:
#   laptop_mcp_ide_config_path <app_dir>
#
# app_dir: Cursor | Code
#
laptop_mcp_ide_config_path() {
  local app_dir="$1"
  local relative_path="$app_dir/User/mcp.json"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "$HOME/Library/Application Support/$relative_path"
  else
    echo "$(laptop_xdg_dir config)/$relative_path"
  fi
}

# Resolve the list of MCP providers to target
#
# Usage:
#   laptop_mcp_providers [provider...]
#
# When no providers are passed, uses LAPTOP_MCP_PROVIDERS (default: auto).
# The value "auto" sniffs installed provider CLIs from the candidate list.
#
laptop_mcp_providers() {
  local providers=()

  if [ "$#" -gt 0 ]; then
    providers=("$@")
  else
    local raw="${LAPTOP_MCP_PROVIDERS:-auto}"
    raw="${raw//,/ }"
    # shellcheck disable=SC2206
    providers=($raw)
  fi

  if [ "${#providers[@]}" -eq 1 ] && [ "${providers[0]}" = "auto" ]; then
    laptop_filter_command_exists "${__LAPTOP_MCP_PROVIDER_CANDIDATES[@]}"
    return 0
  fi

  echo "${providers[@]}"
}

# Load a provider install hook if not already loaded
#
# Usage:
#   laptop_mcp_ensure_load_provider <provider>
#
laptop_mcp_ensure_load_provider() {
  local provider="$1"
  local function_name="laptop_mcp_ensure__$provider"

  if laptop_function_exists "$function_name"; then
    return 0
  fi

  local definition_file="${LAPTOP_LIB_DIR}/function/mcp_ensure_${provider}.sh"
  if [ -f "$definition_file" ]; then
    # shellcheck disable=SC1090
    source "$definition_file"
  fi

  laptop_function_exists "$function_name"
}

# Ensure a remote MCP server is installed across providers
#
# Usage:
#   laptop_mcp_ensure <name> <url> [provider...]
#
# Providers may be passed as arguments, or via LAPTOP_MCP_PROVIDERS.
# When unset, defaults to "auto" (sniff installed CLIs).
#
laptop_mcp_ensure() {
  local name="$1"
  local url="$2"
  shift 2

  if [ -z "$name" ] || [ -z "$url" ]; then
    laptop_log error "Usage: laptop_mcp_ensure <name> <url> [provider...]"
    return 1
  fi

  local providers
  # shellcheck disable=SC2207
  providers=($(laptop_mcp_providers "$@"))

  if [ "${#providers[@]}" -eq 0 ]; then
    laptop_log warn "No MCP providers available"
    return 0
  fi

  local exit_code=0
  local provider
  for provider in "${providers[@]}"; do
    if ! laptop_mcp_ensure_load_provider "$provider"; then
      laptop_step_start_status "present" "absent" "MCP provider '$provider'"
      laptop_step_status "fail"
      laptop_log error "Unknown MCP provider '$provider'"
      exit_code=1
      continue
    fi

    if ! "laptop_mcp_ensure__$provider" "$name" "$url"; then
      exit_code=1
    fi
  done

  return "$exit_code"
}
