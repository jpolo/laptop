#!/usr/bin/env bash

laptop_require "laptop_apt_ensure_package"
laptop_require "laptop_step_start_status"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"
laptop_require "laptop_path_print"

# Ensure an apt keyring is present, downloading `key_url` and storing the
# dearmored key at `keyring_path` (modern signed-by layout).
#
# Usage:
#   laptop_apt_ensure_keyring <keyring_path> <key_url> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_apt_ensure_keyring() {
  local keyring_path="$1"
  local key_url="$2"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local current_resource_status
  current_resource_status=$(test -f "$keyring_path" && echo "present" || echo "absent")
  local message
  message="apt keyring '$(laptop_path_print "$keyring_path")'"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_apt_ensure_package "wget"
      laptop_apt_ensure_package "gnupg2"
      local keyring_dir
      keyring_dir="$(dirname "$keyring_path")"
      laptop_step_eval "sudo mkdir -p -m 755 $(quote "$keyring_dir") \
        && wget -nv -O- $(quote "$key_url") | sudo gpg --dearmor -o $(quote "$keyring_path") \
        && sudo chmod go+r $(quote "$keyring_path")"
    else
      laptop_step_eval "sudo rm -f $(quote "$keyring_path")"
    fi
  fi
}
