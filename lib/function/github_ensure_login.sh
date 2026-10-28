#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_step_exec"

# Return success when the held scope is the required scope, or a scope that
# implies it. GitHub's hierarchy is read:X < write:X < admin:X.
_laptop_github_scope_satisfies() {
  local held_scope="$1"
  local required_scope="$2"
  local required_prefix
  local required_name

  if [ "$held_scope" = "$required_scope" ]; then
    return 0
  fi

  case "$required_scope" in
  *:*) ;;
  *) return 1 ;;
  esac

  required_prefix="${required_scope%%:*}"
  required_name="${required_scope#*:}"

  case "$required_prefix" in
  read)
    [ "$held_scope" = "write:${required_name}" ] || [ "$held_scope" = "admin:${required_name}" ]
    ;;
  write)
    [ "$held_scope" = "admin:${required_name}" ]
    ;;
  *)
    return 1
    ;;
  esac
}

# Return success when every required scope is present in the current scopes list.
_laptop_github_scopes_include_all() {
  local current_scopes="$1"
  local required_scopes="$2"
  local required_scope
  local held_scope
  local satisfied

  while IFS= read -r required_scope; do
    [ -z "$required_scope" ] && continue
    satisfied=1
    while IFS= read -r held_scope; do
      [ -z "$held_scope" ] && continue
      if _laptop_github_scope_satisfies "$held_scope" "$required_scope"; then
        satisfied=0
        break
      fi
    done < <(printf '%s\n' "$current_scopes" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [ "$satisfied" -eq 0 ] || return 1
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

  # gh --scopes is a comma-separated list and treats surrounding spaces as
  # part of the scope name.
  scopes="${scopes//[[:space:]]/}"

  current_scopes=$(gh auth status -h "$host" --json hosts \
    --jq ".hosts[\"$host\"] | map(select(.active and .state == \"success\")) | .[0].scopes // empty" 2>/dev/null)
  if [ -n "$current_scopes" ]; then
    logged_in=1
  fi

  if [ "$logged_in" -eq 0 ]; then
    resource_current_status="absent"
  elif _laptop_github_scopes_include_all "$current_scopes" "$scopes"; then
    resource_current_status="present"
  else
    resource_current_status="absent"
  fi

  laptop_step_start_status "$resource_status" "$resource_current_status" "Github account logged in"
  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  elif [ "$logged_in" -eq 1 ]; then
    GITHUB_TOKEN='' laptop_step_exec --interactive -- gh auth refresh -h "$host" --scopes "$scopes"
  else
    GITHUB_TOKEN='' laptop_step_exec --interactive -- gh auth login -p ssh -h "$host" --scopes "$scopes" -w
  fi
}
