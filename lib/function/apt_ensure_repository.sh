#!/usr/bin/env bash

laptop_require "laptop_apt_ensure_key"
laptop_require "laptop_step_start_status"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"
laptop_require "laptop_path_print"

# Add `repo_url` as an apt repository
#
# Usage:
#   laptop_apt_ensure_repository <repo_url> [repo_key] [--keyring-path <path>] [--sources-list <file>] [--status present|absent]
#
# Options:
#   repo_key              Legacy apt-key URL (required when --keyring-path is not set)
#   --keyring-path path   Build a signed-by deb line referencing an existing keyring
#   --sources-list file   Write repository to a dedicated sources list file
#   --status present|absent
#
laptop_apt_ensure_repository() {
  local repo_url="$1"
  local repo_key=""
  local resource_status="present"
  local keyring_path=""
  local sources_list=""

  shift
  if [[ $# -gt 0 && "$1" != -* ]]; then
    repo_key="$1"
    shift
  fi
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    --keyring-path)
      keyring_path="$2"
      shift 2
      ;;
    --sources-list)
      sources_list="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  if [ -z "$keyring_path" ] && [ -n "$repo_key" ] && [ "$resource_status" = "present" ]; then
    laptop_apt_ensure_key "$repo_key"
  fi

  local deb_line
  if [ -n "$keyring_path" ]; then
    deb_line="deb [arch=$(dpkg --print-architecture) signed-by=$keyring_path] $repo_url"
  else
    deb_line="deb $repo_url"
  fi

  local current_resource_status
  if [ -n "$sources_list" ]; then
    current_resource_status=$(
      test -f "$sources_list" && grep -qF "$repo_url" "$sources_list" && echo "present" || echo "absent"
    )
  else
    current_resource_status=$(
      grep -q "^deb .*$repo_url" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null && echo "present" || echo "absent"
    )
  fi

  local message
  if [ -n "$sources_list" ]; then
    message="apt repository '$(laptop_path_print "$sources_list")'"
  else
    message="apt repository '$repo_url'"
  fi

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      if [ -n "$sources_list" ]; then
        laptop_step_eval "echo $(quote "$deb_line") | sudo tee $(quote "$sources_list") > /dev/null && sudo apt-get update"
      else
        laptop_step_eval "echo $(quote "$deb_line") | sudo tee -a /etc/apt/sources.list.d/custom.list >/dev/null && sudo apt-get update"
      fi
    else
      if [ -n "$sources_list" ]; then
        laptop_step_eval "sudo rm -f $(quote "$sources_list")"
      else
        laptop_step_eval "sudo sed -i '\\|$repo_url|d' /etc/apt/sources.list.d/custom.list"
      fi
    fi
  fi
}
