#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_eval"

# Return success when every required scope is present in the current scopes list.
.laptop_github_scopes_include_all() {
  local current_scopes="$1"
  local required_scopes="$2"
  local required_scope

  while IFS= read -r required_scope; do
    [ -z "$required_scope" ] && continue
    if ! printf '%s\n' "$current_scopes" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -Fxq "$required_scope"; then
      return 1
    fi
  done < <(printf '%s\n' "$required_scopes" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  return 0
}

# Ensure Github account is logged in with the required OAuth scopes.
# Logs in when absent, or refreshes the token when logged in but under-scoped.
# See gh auth --help for more information
#
# Usage:
#   laptop_github_ensure_login [--host <host>] [--scopes <scopes>]
#
# Options:
#   --host <host>
#   --scopes <scopes>
#
laptop_github_ensure_login() {
  local host="github.com"
  local scopes="gist, read:org, repo"
  local resource_status="present"
  local resource_current_status
  local logged_in=0
  local current_scopes

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --host)
      host="$2"
      shift 2
      ;;
    -s | --scopes)
      scopes="$scopes,$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  current_scopes=$(gh auth status -h "$host" --json hosts \
    --jq ".hosts[\"$host\"] | map(select(.active and .state == \"success\")) | .[0].scopes // empty" 2>/dev/null)
  if [ -n "$current_scopes" ]; then
    logged_in=1
  fi

  if [ "$logged_in" -eq 0 ]; then
    resource_current_status="absent"
  elif .laptop_github_scopes_include_all "$current_scopes" "$scopes"; then
    resource_current_status="present"
  else
    resource_current_status="absent"
  fi

  laptop_step_start_status "$resource_status" "$resource_current_status" "Github account logged in"
  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  elif [ "$logged_in" -eq 1 ]; then
    GITHUB_TOKEN='' laptop_step_exec gh auth refresh -h "$host" --scopes "$scopes"
  else
    laptop_step_eval "GITHUB_TOKEN='' gh auth login -p ssh -h \"$host\" --scopes \"$scopes\" -w && eval \"\$(ssh-agent -s)\""
  fi
}
