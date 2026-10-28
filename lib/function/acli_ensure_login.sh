#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_die"

# Ensure the user is logged into the Atlassian CLI (acli) for Jira.
# Logs in when not already authenticated.
#
# Usage:
#   laptop_acli_ensure_login [--site <site>] [--email <email>]
#
# Options:
#   --site <site>
#   --email <email>
#
# When both --site and --email are set, authenticates with an API token
# read from stdin. When neither is set, uses browser (OAuth) login.
# Providing only one of --site or --email is an error.
#
laptop_acli_ensure_login() {
  local site=""
  local email=""
  local resource_status="present"
  local resource_current_status

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --site)
      site="$2"
      shift 2
      ;;
    -e | --email)
      email="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  if [ -n "$site" ] && [ -z "$email" ]; then
    laptop_die "laptop_acli_ensure_login: --email is required when --site is set"
  elif [ -z "$site" ] && [ -n "$email" ]; then
    laptop_die "laptop_acli_ensure_login: --site is required when --email is set"
  fi

  if acli jira auth status &>/dev/null; then
    resource_current_status="present"
  else
    resource_current_status="absent"
  fi

  laptop_step_start_status "$resource_status" "$resource_current_status" "Atlassian account logged in"
  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  elif [ -n "$site" ] && [ -n "$email" ]; then
    laptop_step_exec --interactive -- acli jira auth login --site "$site" --email "$email" --token
  else
    laptop_step_exec --interactive -- acli jira auth login --web
  fi
}
